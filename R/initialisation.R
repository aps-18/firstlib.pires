# Q1 ----

#usethis::create_package("firstlib.pires")
#ça va créer un nouveau projet avec la structure d'un package
#firstlib.pires/
#   ├── R/
#   ├── DESCRIPTION
#   ├── NAMESPACE
#   ├── firstlib.pires.Rproj


# Q2 ----
usethis::use_git()

#projet git créé en local


# Q3 ----

#créer nouveau répertoire sur github

#usethis::use_git_remote("origin", "https://github.com/aps-18/firstlib.pires.git")
#usethis::git_remotes() #vérif


# Q4 ----

#git push -u origin master  dans le terminal

#La branche principale est master.
#Cela dépend de la configuration de Git, certaines versions utilisent encore master par défaut, bien que la convention actuelle soit d’utiliser main.


# Q5 ----

usethis::use_mit_license()
#pour choisir une license et modifier le fichier description à ce niveau direct

# Q6 ----

usethis::use_r("velo")

#remplir avec les fonctions et leur documentation

usethis::use_package("dplyr", type = "Imports")
usethis::use_package("ggplot2", type = "Imports")
#Renseigner les dépendances avec Roxygen2 car j’utilise des fonctions de dplyr et ggplot2
#change les imports dans le fichier DESCRIPTION


# Q7 ----

devtools::document()
#créer le dossier man/
#générer les fichiers .Rd
#mettre à jour NAMESPACE


