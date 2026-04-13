utils::globalVariables(
  c(
    "Total",
    "numero_boucle",
    "probabilite_anomalie",
    "jour_semaine",
    "boucle",
    "date",
    "total_trajets",
    "moyenne"
  )
)

#' Filtrer les anomalies des trajets vélos
#'
#' Filtre les observations dont la probabilité de présence d'anomalies est
#' "Forte" ou "Faible", ainsi que les lignes dont le total est négatif ou
#' supérieur à 10000.
#'
#' @param df_velo Un data.frame de trajets vélos.
#'
#' @return Un data.frame filtré.
#' @export
filtre_anomalie <- function(df_velo) {
  df_velo |>
    dplyr::filter(!probabilite_anomalie %in% c("Forte", "Faible")) |>
    dplyr::filter(Total > 0, Total < 10000)
}

#' Compter le nombre total de trajets
#'
#' Calcule la somme de la colonne `Total`.
#'
#' @param df_velo Un data.frame de trajets vélos.
#'
#' @return Un nombre correspondant au total des trajets.
#' @export
compter_nombre_trajets <- function(df_velo) {
  df_velo |>
    dplyr::pull(Total) |>
    sum(na.rm = TRUE)
}

#' Compter le nombre de boucles
#'
#' Compte le nombre de boucles distinctes à partir de la colonne
#' `numero_boucle`.
#'
#' @param df_velo Un data.frame de trajets vélos.
#'
#' @return Un entier correspondant au nombre de boucles distinctes.
#' @export
compter_nombre_boucle <- function(df_velo) {
  df_velo |>
    dplyr::pull(numero_boucle) |>
    unique() |>
    length()
}

#' Trouver le trajet maximal
#'
#' Retourne la ligne correspondant au maximum de trajets, après filtrage des
#' anomalies, ainsi que deux moyennes de comparaison.
#'
#' @param df_velo Un data.frame de trajets vélos.
#'
#' @return Un data.frame d'une ligne contenant la boucle, la date, le total
#' maximal, la moyenne sur la boucle et la moyenne sur la date.
#' @export
trouver_trajet_max <- function(df_velo) {
  df_sans_anomalie <- df_velo |>
    filtre_anomalie()

  ligne_max <- df_sans_anomalie |>
    dplyr::slice_max(Total, n = 1)

  boucle_max <- ligne_max$boucle[1]
  date_max <- ligne_max$date[1]
  total_max <- ligne_max$Total[1]

  moyenne_par_jour_boucle <- df_sans_anomalie |>
    dplyr::filter(boucle == boucle_max) |>
    dplyr::summarise(moyenne = mean(Total, na.rm = TRUE)) |>
    dplyr::pull(moyenne)

  moyenne_par_boucle_date <- df_sans_anomalie |>
    dplyr::filter(date == date_max) |>
    dplyr::summarise(moyenne = mean(Total, na.rm = TRUE)) |>
    dplyr::pull(moyenne)

  data.frame(
    boucle = boucle_max,
    date = date_max,
    Total = total_max,
    moyenne_par_jour_boucle = moyenne_par_jour_boucle,
    moyenne_par_boucle_date = moyenne_par_boucle_date
  )
}

#' Calculer la distribution hebdomadaire des trajets
#'
#' Additionne le nombre de trajets par jour de la semaine.
#'
#' @param df_velo Un data.frame de trajets vélos.
#'
#' @return Un tibble contenant le total des trajets par jour de la semaine.
#' @export
calcul_distribution_semaine <- function(df_velo) {
  df_velo |>
    dplyr::group_by(jour_semaine) |>
    dplyr::summarise(total_trajets = sum(Total, na.rm = TRUE), .groups = "drop")
}

#' Représenter la distribution hebdomadaire des trajets
#'
#' Produit un graphique en barres du nombre de trajets par jour de la semaine.
#'
#' @param df_velo Un data.frame de trajets vélos.
#'
#' @return Un graphique ggplot.
#' @export
plot_distribution_semaine <- function(df_velo) {
  df_velo |>
    filtre_anomalie() |>
    calcul_distribution_semaine() |>
    ggplot2::ggplot(
      ggplot2::aes(
        x = factor(jour_semaine),
        y = total_trajets
      )
    ) +
    ggplot2::geom_col(fill = "cornflowerblue") +
    ggplot2::labs(
      x = "Jour de la semaine",
      y = "Nombre de trajets",
      title = "Distribution hebdomadaire des trajets"
    ) +
    ggplot2::theme_bw()
}

#' Filtrer les trajets par numéro de boucle
#'
#' Sélectionne uniquement les lignes correspondant aux numéros de boucle
#' fournis en entrée. Si `numero` vaut `NULL`, le jeu de données est renvoyé
#' sans filtrage.
#'
#' @param trajet Un data.frame de trajets vélos.
#' @param numero Un vecteur de numéros de boucle, ou `NULL`.
#'
#' @return Un data.frame filtré.
#' @export
filtrer_trajet <- function(trajet, numero) {
  if (is.null(numero)) {
    return(trajet)
  }

  trajet |>
    dplyr::filter(numero_boucle %in% numero)
}
