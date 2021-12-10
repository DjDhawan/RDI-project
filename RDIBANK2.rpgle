     H
     DRDIBANK2         PR
     DLOGINID                        10A
     DROLE                            1A
     D
     DRDIBANK2         PI
     DLOGINID                        10A
     DROLE                            1A
     D
     D ADD             PR            10S 0
     D                               10S 0
     D                                6S 0
     D
     D SUB             PR            10S 0
     D                               10S 0
     D                                6S 0
     D
     FCUSTOMERPFUF A E           K DISK
     FBALANCED  CF   E             WORKSTN
     F                                     SFILE(SFL1:RRN)
     F                                     INFDS(infds)
     D infds           DS
     D CurrentRRN            378    379B 0
     D RRN             S              4  0
     D NUMBERS         S             10A   INZ('0123456789')
     D FINDCHAR        DS
     D  NUM                           6S 0
     D BAL             S             10S 0
     D NewBalance      S             10S 0
      /free
        Exsr $INITSFL;
        IF ROLE = 'A';
          Exsr $LOADSFL;
        ELSE;
          Exsr $LOADCust;
        ENDIF;
        DOW *IN03 = *OFF;
          Exsr $DISPLAYSFL;
          *IN51 = *OFF;         // S_option DSPATR(RI PC)
          If *IN05 = *ON;
            Exsr $INITSFL;
            IF ROLE = 'A';
               Exsr $LOADSFL;
            ELSE;
               Exsr $LOADCust;
            ENDIF;
            ITER;
          ENDIF;
          IF *IN03 = *ON;
           Leave;
          ENDIF;
          If *IN05 <> *ON AND *IN03 <> *ON  AND *IN12 <> *ON AND *IN09 <> *ON;
            EXSR $VALSFL;
            If MSG = *Blanks;
              EXSR $WINDOW;
            ENDIF;
          ENDIF;
        ENDDO;
        *inlr = *on;
      /end-free

      /free
        begsr $INITSFL;
          *IN22 = *OFF;        // SFLDSP, SFLDSPCTL
          *IN21 = *ON;         // SFLCLR
          S_OPTION = *BLANKS;
          MSG = *BLANKS;
          WRITE CTL1;
          RRN = 0;
        ENDSR;
      /end-free

      /free
        begsr $LOADSFL;
          *IN21 = *OFF;      // SFLCLR
          SFLRRN = 1;
          RRN = 0;
          Setll *LOVAL CUSTOMERPF;
          READ CUSTOMERPF;
          DOW NOT %EOF(CUSTOMERPF);
            RRN = RRN + 1;
            IF RRN > 9999;
               LEAVE;
            ENDIF;
            S_FNAME = FNAME;
            S_LNAME = LNAME;
            S_BALANCE = Balance;
            IF *IN05 = *ON;
              S_OPTION = ' ';
            ENDIF;
            WRITE SFL1;
            READ CUSTOMERPF;
          ENDDO;
        ENDSR;
      /end-free

      /free
        begsr $LOADCust;
          *IN21 = *OFF;      // SFLCLR
          SFLRRN = 1;
          RRN = 1;
          FNAME = LOGINID;
          Setll FNAME CUSTOMERPF;
          READ CUSTOMERPF;
          S_FNAME = FNAME;
          S_LNAME = LNAME;
          S_BALANCE = Balance;
          IF *IN05 = *ON;
             S_OPTION = ' ';
          ENDIF;
          WRITE SFL1;
        ENDSR;
      /end-free

      /free
        begsr $DISPLAYSFL;
          *IN22 = *ON;          // SFLDSP, SFLDSPCTL
          Write RECFOOT;
          EXFMT CTL1;
        ENDSR;
       /end-free

      /free
        begsr $VALSFL;
          READC SFL1;
          MSG = *blanks;
          DOW NOT%EOF;
          *IN51 = *OFF;
            If S_Option <> 'U' AND S_Option <> ' ';
              *IN51 = *ON;                             // S_option DSPATR(RI PC)
              MSG = 'Valid value is Only ''U''';
            ENDIF;
            *IN50 = *ON;          // SFLNXTCHG
            UPDATE SFL1;
            READC SFL1;
          ENDDO;
        ENDSR;
       /end-free

       /free
         BEGSR $WINDOW;
           READC SFL1;
           DOW NOT%EOF;
             IF S_OPTION <> *BLANKS;
               EXSR $LOADWIN;
             ENDIF;
             READC SFL1;
           ENDDO;
            Exsr $INITSFL;
            IF ROLE = 'A';
               Exsr $LOADSFL;
            ELSE;
               Exsr $LOADCust;
            ENDIF;
         ENDSR;
       /end-free

       /free
         begsr $LOADWIN;
            *IN31 = *OFF;
            *IN32 = *OFF;
            NUM = *ZERO;
            BAL = *ZERO;
            W_FNAME = S_FNAME;
            W_LNAME = S_LNAME;
            W_BALANCE = S_BALANCE;
            W_MSG = 'Enter the Deposit/Withdrawl amount';
            W_AMOUNT = *ZERO;
            W_OPTION = *BLANKS;
            DOW W_MSG <> *BLANKS;
              EXFMT UPDCUST;
              IF *IN12 = *ON;
                *IN12 = *OFF;
                LEAVE;
              ENDIF;
              *IN31 = *OFF;
              *IN32 = *OFF;
              W_MSG = *BLANKS;
              If W_OPTION <> 'D' AND W_OPTION <> 'W';
                W_MSG = 'Valid values are D and W';
                *IN32 = *ON;
              ENDIF;
              NUM = W_AMOUNT;
              BAL = W_Balance;
              If %check(NUMBERS:FINDCHAR) > 0;        // Numeric check
                W_MSG = 'Only numeric value is allowed';
                *IN31 = *ON;
              ENDIF;
              IF W_MSG = *BLANKS;
                IF W_OPTION = 'D';
                  NewBalance = Add(BAL:NUM);
                Else;
                  NewBalance = Sub(BAL:NUM);
                ENDIF;
                EXSR $UPDRCD;
              ENDIF;
            ENDDO;
         ENDSR;
       /end-free

       /free
        BEGSR $UPDRCD;
          FNAME = W_FNAME;
          CHAIN FNAME CUSTOMERPF;
          IF %found;
            BALANCE = NewBalance;
            UPDATE CUST;
          ENDIF;
        ENDSR;
       /end-free

     P ADD             B
     D                 PI            10S 0
     D num1                          10S 0
     D num2                           6S 0
     D Sum             S             10S 0
       /free
          Sum = Num1 + Num2;
          Return Sum;
       /end-free
     P ADD             E

     P SUB             B
     D                 PI            10S 0
     D num1                          10S 0
     D num2                           6S 0
     D Diff            S             10S 0
       /free
          Diff = Num1 - Num2;
          Return Diff;
       /end-free
     P SUB             E                     
