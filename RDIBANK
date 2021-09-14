     H
     FBANKD     CF   E             WORKSTN
     FADMINPF   IF   E           K DISK
     D
     DRDIBANK2         PR                  EXTPROC('RDIBANK2')
     DLOGINID                        10A
     DROLE                            1A
     D
      /free
        DOW *IN03 = *OFF;
          EXFMT MAIN;
          IF *IN05 = *ON;
             EXSR $INITIALIZE;
             ITER;
          ELSEIF  *IN03 = *ON;
             LEAVE;
          ENDIF;
          *IN10 = *OFF;
          *IN20 = *OFF;
          *IN30 = *OFF;
          Clear Msg;
          EXSR $VALIDATE;
          If Msg = *Blank;
            RDIBANK2(lOGINID:ROLE);
            EXSR $INITIALIZE;
          ENDIF;
        ENDDO;
        *INLR = *ON;
      /end-free

      /free
        BEGSR $INITIALIZE;
              CLEAR LOGINID;
              CLEAR PASS;
              CLEAR OPTION;
              CLEAR MSG;
             *IN40 = *OFF;
             *IN10 = *OFF;
             *IN20 = *OFF;
             *IN30 = *OFF;
        ENDSR;
      /end-free

       /free
        BEGSR $VALIDATE;
          If  (loginID = *Blank);
              *IN40 = *ON;
              *IN10 = *ON;
               MSG = 'Please enter Login ID';
               LEAVESR;
          Elseif  (Pass = *Blank);
              *IN40 = *ON;
              *IN20 = *ON;
               MSG = 'Please enter the password';
               LEAVESR;
          ElseIf  (Option = *blank);
              *IN40 = *ON;
              *IN30 = *ON;
               MSG = 'Please enter login as..';
               LEAVESR;
          ENDIF;

          If  OPTION = 'A' OR OPTION = 'C';
             *IN30 = *OFF;
          ELSE;
            *IN40 = *ON;
            *IN30 = *ON;
             MSG = 'Option value should be either A or C';
             LEAVESR;
          ENDIF;

        UserID = LoginID;
        chain (UserID)Adminpf;
        If %Found(Adminpf);
          If Role <> Option;
              *IN40 = *ON;
              *IN30 = *ON;
              *IN10 = *ON;
             IF Option = 'A';
               Msg = 'LoginID is not an Admin';
             Else;
               Msg = 'LoginID is not an Customer';
             ENDIF;
             LEAVESR;
          ENDIF;
          If Password <> Pass;
             *IN40 = *ON;
             *IN20 = *ON;
             Msg = 'Incorrect Password';
             LEAVESR;
          ENDIF;
        Else;
         *IN40 = *ON;
         *IN10 = *ON;
          Msg = 'LoginID not found';
          LEAVESR;
        ENDIF;

        ENDSR;
       /end-free        
