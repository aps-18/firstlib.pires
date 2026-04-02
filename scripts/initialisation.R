#Création du dossier scripts pour pouvoir mettre notre code et le lancer
#ne pas avoir de code dans le dossier R, seulement des fonctions et définitions

# Q1 ----

usethis::create_package("firstlib.pires")
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

usethis::use_git_remote("origin", "https://github.com/aps-18/firstlib.pires.git")
usethis::git_remotes() #vérif


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

#à faire dans la console

#devtools::document()  dans console R
#créer le dossier man/
#générer les fichiers .Rd
#mettre à jour NAMESPACE


#devtools::load_all()
#ça simule l’installation de ton package


#?compter_nombre_trajets
#pour vérifier la doc
#on doit voir Tu dois voir :
#-Description
#-Arguments (@param)
#-Value (@return)


# Q8 ----

#devtools::check()
#pour vérifier les dépendances

#ici pas d'erreur
#1 warning à cause des accents dans velo.R, donc on va renommer les colonnes et modifier

#pour modifer nos colonnes qd on importera un jeu de données
#df_velo <- df_velo |>
#dplyr::rename(
#  numero_boucle = `Numéro de boucle`,
#  date = `Date formatée`,
#  probabilite_anomalie = `Probabilité de présence d'anomalies`,
#  jour_semaine = `Jour de la semaine`,
#  boucle = `Boucle de comptage`
#)


#1 note à cause d'un fichier git (inutil donc on a supprimé) et du dossier scripts qu'on garde
#1 autre note à cause de la colonne Total où il ne comprend pas que c'est une colonne
#on va utiliser utils::globalVariables au début de velo.R pour spécifier le nom de nos colonnes


#refaire devtools::check() pour vérifier

