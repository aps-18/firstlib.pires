#fichier pour tester nos fonctions

test_that("filtre_anomalie filtre correctement les anomalies", {
  df_test <- data.frame(
    probabilite_anomalie = c("Forte", "Faible", "Moyenne", "Aucune"),
    Total = c(100, 200, -5, 500),
    stringsAsFactors = FALSE
  )

  res <- filtre_anomalie(df_test)

  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 1)
  expect_equal(res$Total, 500)
  expect_false(any(res$probabilite_anomalie %in% c("Forte", "Faible")))
  expect_true(all(res$Total > 0 & res$Total < 10000))
})

test_that("filtre_anomalie renvoie une erreur si les colonnes nécessaires sont absentes", {
  df_invalide <- data.frame(x = 1:3, y = 4:6)

  expect_error(filtre_anomalie(df_invalide))
})

test_that("compter_nombre_trajets calcule correctement la somme des trajets", {
  df_test <- data.frame(Total = c(10, 20, 30, NA))

  res <- compter_nombre_trajets(df_test)

  expect_type(res, "double")
  expect_equal(res, 60)
  expect_true(res >= 0)
})

test_that("compter_nombre_trajets renvoie une erreur si la colonne Total est absente", {
  df_invalide <- data.frame(x = 1:3)

  expect_error(compter_nombre_trajets(df_invalide))
})

test_that("compter_nombre_boucle compte correctement le nombre de boucles distinctes", {
  df_test <- data.frame(numero_boucle = c(880, 881, 880, 882, 882))

  res <- compter_nombre_boucle(df_test)

  expect_type(res, "integer")
  expect_equal(res, 3L)
  expect_true(res > 0)
})

test_that("compter_nombre_boucle renvoie une erreur si la colonne numero_boucle est absente", {
  df_invalide <- data.frame(x = 1:3)

  expect_error(compter_nombre_boucle(df_invalide))
})

test_that("trouver_trajet_max retourne la ligne du maximum avec les moyennes associées", {
  df_test <- data.frame(
    probabilite_anomalie = c("Aucune", "Aucune", "Forte", "Aucune"),
    Total = c(100, 300, 1000, 200),
    boucle = c("A", "A", "B", "C"),
    date = c("2025-10-20", "2025-10-21", "2025-10-21", "2025-10-21"),
    stringsAsFactors = FALSE
  )

  res <- trouver_trajet_max(df_test)

  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 1)
  expect_equal(res$boucle, "A")
  expect_equal(res$date, "2025-10-21")
  expect_equal(res$Total, 300)
  expect_equal(res$moyenne_par_jour_boucle, 200)
  expect_equal(res$moyenne_par_boucle_date, 250)
})

test_that("trouver_trajet_max renvoie une erreur si les colonnes nécessaires sont absentes", {
  df_invalide <- data.frame(Total = c(1, 2, 3))

  expect_error(trouver_trajet_max(df_invalide))
})

test_that("calcul_distribution_semaine calcule correctement le total par jour", {
  df_test <- data.frame(
    jour_semaine = c("lundi", "lundi", "mardi", "mercredi"),
    Total = c(10, 15, 20, 5),
    stringsAsFactors = FALSE
  )

  res <- calcul_distribution_semaine(df_test, filtre = FALSE)

  expect_s3_class(res, "data.frame")
  expect_true(all(c("jour_semaine", "total_trajets") %in% names(res)))
  expect_equal(res$total_trajets[res$jour_semaine == "lundi"], 25)
  expect_equal(res$total_trajets[res$jour_semaine == "mardi"], 20)
  expect_equal(nrow(res), 3)
})

test_that("calcul_distribution_semaine renvoie une erreur si les colonnes nécessaires sont absentes", {
  df_invalide <- data.frame(x = 1:3)

  expect_error(calcul_distribution_semaine(df_invalide))
})

test_that("plot_distribution_semaine retourne un objet ggplot", {
  df_test <- data.frame(
    probabilite_anomalie = c("Aucune", "Aucune", "Faible", "Aucune"),
    Total = c(10, 20, 999, 15),
    jour_semaine = c("lundi", "mardi", "mardi", "lundi"),
    stringsAsFactors = FALSE
  )

  res <- plot_distribution_semaine(df_test)

  expect_s3_class(res, "ggplot")
})

test_that("plot_distribution_semaine renvoie une erreur si les colonnes nécessaires sont absentes", {
  df_invalide <- data.frame(x = 1:3)

  expect_error(plot_distribution_semaine(df_invalide))
})

test_that("filtrer_trajet filtre correctement les numéros de boucle demandés", {
  df_test <- data.frame(
    numero_boucle = c(880, 881, 882, 880),
    Total = c(10, 20, 30, 40)
  )

  res <- filtrer_trajet(df_test, c(880, 881))

  expect_s3_class(res, "data.frame")
  expect_true(all(res$numero_boucle %in% c(880, 881)))
  expect_equal(nrow(res), 3)
})

test_that("filtrer_trajet renvoie une erreur si la colonne numero_boucle est absente", {
  df_invalide <- data.frame(x = 1:3)

  expect_error(filtrer_trajet(df_invalide, c(880, 881)))
})

test_that("filtrer_trajet renvoie le jeu non filtré si numero est NULL", {
  df_test <- data.frame(
    numero_boucle = c(880, 881, 882),
    Total = c(10, 20, 30)
  )

  res <- filtrer_trajet(df_test, NULL)

  expect_s3_class(res, "data.frame")
  expect_equal(res, df_test)
})

test_that("calcul_distribution_semaine avec filtre = TRUE filtre les anomalies", {
  df_test <- data.frame(
    probabilite_anomalie = c("Aucune", "Forte", "Aucune"),
    Total = c(10, 10000, 20),
    jour_semaine = c("lundi", "lundi", "mardi"),
    stringsAsFactors = FALSE
  )

  res <- calcul_distribution_semaine(df_test, filtre = TRUE)

  expect_s3_class(res, "data.frame")
  expect_equal(res$total_trajets[res$jour_semaine == "lundi"], 10)
})

test_that("calcul_distribution_semaine avec filtre = FALSE garde toutes les données", {
  df_test <- data.frame(
    probabilite_anomalie = c("Aucune", "Forte"),
    Total = c(10, 100),
    jour_semaine = c("lundi", "lundi"),
    stringsAsFactors = FALSE
  )

  res <- calcul_distribution_semaine(df_test, filtre = FALSE)

  expect_equal(res$total_trajets[res$jour_semaine == "lundi"], 110)
})

test_that("calcul_distribution_semaine filtre modifie le résultat", {
  df_test <- data.frame(
    probabilite_anomalie = c("Aucune", "Forte"),
    Total = c(10, 100),
    jour_semaine = c("lundi", "lundi"),
    stringsAsFactors = FALSE
  )

  res_filtre <- calcul_distribution_semaine(df_test, filtre = TRUE)
  res_sans_filtre <- calcul_distribution_semaine(df_test, filtre = FALSE)

  expect_true(res_filtre$total_trajets != res_sans_filtre$total_trajets)
})
