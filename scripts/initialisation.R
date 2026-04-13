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
#on doit voir :
#-Description
#-Usage
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


# Q9 ----

#import
library(readr)
df_velo <- read_delim("244400404_comptages-velo-nantes-metropole.csv", delim = ";")

#filtrer les vacances de Toussaint 2025
library(dplyr)
df_velo <- df_velo |>
  filter(`Date formatée` >= "2025-10-18",
         `Date formatée` <= "2025-11-03")

#on renomme dcp nos colonnes
df_velo <- df_velo |>
dplyr::rename(
  numero_boucle = `Numéro de boucle`,
  date = `Date formatée`,
  probabilite_anomalie = `Probabilité de présence d'anomalies`,
  jour_semaine = `Jour de la semaine`,
  boucle = `Boucle de comptage`
)

#ajouter les données dans le package
usethis::use_data(df_velo, overwrite = TRUE)

#vérif
devtools::load_all()
df_velo


# Q10 ----

#créer un fichier de documentation
usethis::use_r("data-df_velo")

#la compléter, la remplir

#vérif
devtools::document()
devtools::load_all()
?df_velo


# Q11 ----

#git checkout -b brancheQ11  dans le terminal
#pour créer une nouvelle branche

#git branch
#pour vérifier


#ajouter la fonction filtrer_trajet dans velo.R


#vérif
devtools::document()
devtools::load_all()
?filtrer_trajet

#test
filtrer_trajet(trajet = df_velo, numero = c(880, 881))

#faire commit/push (via la brancheQ11)

#Sur GitHub (dans repo, Compare & pull request, Create pull request, Merge pull request)
#Sur RStudio (onglet Git, master, Pull)


# Q12 ----

usethis::use_testthat()

usethis::use_test("velo")
#Ça va créer un fichier dans : tests/testthat/test-velo.R


# Q13 ----

devtools::test()
#pour tester les fonctions via le fichier créé


#couverture de test
covr::package_coverage() #validé car > 80%
covr::report()


# Q14 ----

#ajouter un test pour le fonction filtrer_trajet() dans le fichier test-velo.R
#erreur donc on modifie la fonction filtrer_trajet() dans le fichier velo.R

devtools::test() #tester les tests
devtools::document() #remettre la doc à jour


# Q15 ----

usethis::use_vignette("utilisation-velo") #création d'un fichier dans vignettes/utilisation-velo.Rmd
#modifier la vignette

devtools::build_vignettes() #générer la vignette
#ou devtools::check()

#vérifier dans doc/utilisation-velo.html


# Q16 ----

usethis::use_pkgdown()
pkgdown::build_site() #construire le site

#vérifier dans le dossier docs

#dans les références on voit toutes nos fonctions
#dans articles, il y a nos vignettes


# Q17 ----

#faire un commit/push

# Q18 ----

#restart session R

remotes::install_github("aps-18/firstlib.pires")
#Installer le package depuis répertoire GitHub

library(firstlib.pires)

plot_distribution_semaine(df_velo) #vérif


# Q19 ----

#git checkout -b feat  dans la console pour faire une nouvelle branche et aller dessus
#git branch  pour vérifier

#modifier la fonction calcul_distribution_semaine() dans R/velo.R

devtools::document() #pour mettre à jour

#exemples pour tester si ça marche
calcul_distribution_semaine(df_velo)
calcul_distribution_semaine(df_velo, filtre = TRUE)
calcul_distribution_semaine(df_velo, filtre = FALSE)


# Q20 ----

#documentation mise à jour dans R/velo.R (avec @param...)

#rajouter des tests dans tests/testthat/test-velo.R

devtools::test() #lancer les tests


# Q21 ----

#faire un commit


