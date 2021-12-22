@ECHO off

REM Details des versions :
REM v1.0.0 - Version d'origine 
REM v2.0.0 - Recuperation du message et de de la description par un input
REM v2.0.1 - Mise en place d'origine et branche par defaut
REM v2.0.2 - Mise en place de la confirmation
REM v2.0.3 - Correction d'un bug majeur des valeurs par defaut d'origin et branche
REM v2.0.4 - Déplacement de la vérIFication des saisies message et desctiption
REM v2.0.5 - Mise en valeur des retours git, add commit et push
REM v2.0.6 - Ajout de la possibilité de ne pas mettre de description au commit

SET message=
SET description=
SET origin=
SET branch=
SET continue=

IF NOT "%1" == "" GOTO help 
IF not exist .git\ GOTO start ELSE GOTO nogit

:start
SET continue=
ECHO GITTER v2.0.6
ECHO.

:message
SET /P message=Entrer le message du commit (ex. Create component (Button) - v0.1.5 ) : 
IF "%message%"=="" GOTO error-message
ECHO.

:description
SET /P description=Entrer une description (ex. Creating Button structure, logic and design) : 
ECHO.

SET /P origin=Entrer la source (ex. origin(defaut) ) : 
ECHO.

SET /P branch=Entrer la branche en cours (ex. main(defaut)) : 
ECHO.


IF "%origin%"=="" SET origin=origin
IF "%branch%"=="" SET branch=main

ECHO Les commandes suivantes vont etre executees :
ECHO.
ECHO.  - git add .
IF "%description%"=="" (
ECHO.  - git commit -m "%message%"
) ELSE (
ECHO.  - git commit -m "%message%" -m "%description%"
)
ECHO.  - git push -u %origin% %branch%
ECHO.

:continue
SET /P continue=Voulez-vous continuer (oui(defaut) / non / refaire) ? : 

IF "%continue%"=="non" GOTO cancel
IF "%continue%"=="refaire" GOTO cancel
IF "%continue%"=="oui" GOTO commit
IF "%continue%"=="" (GOTO commit) ELSE (GOTO error-continue)

:error-message
ECHO /!\ Erreur de saisie : un message doit etre entre.
GOTO message

:error-description
ECHO /!\ Erreur de saisie : une description doit etre entree.
GOTO description

:error-continue
ECHO /!\ Erreur de saisie entrer: 
ECHO.  - "oui" pour continuer,
ECHO.  - "refaire" pour recommencer ou
ECHO.  - "non" pour annuler.
GOTO continue

:nogit
ECHO ----------------------------------------
ECHO| /!\ ERREUR : dossier .GIT non trouve |
ECHO ----------------------------------------
ECHO.
GOTO end

:help
ECHO Effectue les commandes GIT de base :
ECHO.  - git add .
ECHO.  - git commit -m "[un message]" -m "[une description]"
ECHO.  - git push -u [source] [branch]
ECHO.
ECHO Pour acceder à l'aide :
ECHO     Executer la commande :
ECHO   - GITTER /? ou GITTER /help ou GITTER --help ou GITTER -h
ECHO.
ECHO Utilisation :
ECHO  1) Executer la commandes :
ECHO.  - GITTER
ECHO  2) Entrer les informations correspondantes :
ECHO.  - entrer le message du commit (ex. : Create component (Button) - v0.1.5 ),
ECHO.  - entrer une description (ex. : Creating Button structure, logic and  design),
ECHO.  - entrer la source (ex. : origin ),
ECHO.  - entrer la branche en cours (ex. : main).
ECHO.
ECHO.                                        Didier PASCAREL
GOTO end

:commit
ECHO ---- COMMIT et ADD -----
ECHO git add .
ECHO ============ REPONSE ============
git add .
ECHO ========================== ADD ==
pause
IF "%description%"=="" (
ECHO git commit -m "%message%"
ECHO ============ REPONSE ============
git commit -m "%message%"
) ELSE (
ECHO git commit -m "%message%" -m "%description%"
ECHO ============ REPONSE ============
git commit -m "%message%" -m "%description%"
)
ECHO ======================= COMMIT ==
SET message=
SET description=
ECHO.
GOTO push

:push
ECHO ---- PUSH -----
ECHO git push -u %origin% %branch%
ECHO ============ REPONSE ============
git push -u %origin% %branch%
ECHO ========================= PUSH ==
SET origin=
SET branch=
ECHO.
GOTO end

:cancel
SET message=
SET description=
SET origin=
SET branch=
ECHO Operation annulee
IF "%continue%"=="refaire" GOTO start
SET continue=

:end