#' Star Systems Module
#' @name module_star_systems
#' @details
#' This module provides functionality for exploring star systems and their planets.
#' Provides a handy UI for selecting a star system. The star is visualized alongside its planets and
#' their orbits. The display provides basic information about the system itself, as well as
#' particular planets. A legend is available for the plot.
NULL

#' @param id A unique identifier for the module.
#' @returns A Shiny UI object.
#' @describeIn module_star_systems UI function for the module.
#' @export
star_systems_ui = function(id) {
  ns = shiny::NS(id)

  bslib::layout_sidebar(
    sidebar = shiny::tagList(
      search_ui(ns("search_star_systems"), label = "Search star:", random = TRUE),
      system_plot_settings_ui(ns("system_plot_settings")),
      search_ui(ns("search_planets"), label = "Select planet:", random = FALSE)
    ),
    shiny::div(
      style = htmltools::css(
        "height" = "100%",
        "display" = "grid",
        "grid-template-columns" = "1fr 1fr",
        "grid-template-rows" = "2fr 1fr",
        "row-gap" = "0",
        "column-gap" = "1rem"
      ),
      bslib::card(
        style = htmltools::css(
          grid_row = "1 / span 2",
          grid_column = "1"
        ),
        bslib::card_header("System map"),
        bslib::card_body(
          style = htmltools::css(
            "padding" = "0",
            "padding-bottom" = "5px",
            "margin" = "0",
          ),
          visualize_star_system_ui(ns("visualize_star_systems")),
        )
      ),
      bslib::card(
        bslib::card_header("Planet details"),
        bslib::card_body(
          planet_details_ui(ns("planet_details"))
        )
      ),
      bslib::card(
        style = htmltools::css(
          "grid-row" = "2",
          "grid-column" = "2",
        ),
        bslib::card_header("System info"),
        bslib::card_body(
          system_info_ui(ns("system_info"))
        )
      )
    )
  )
}

#' @param id A unique identifier for the module.
#' @param data A reactive expression that returns a data frame containing star system data.
#' @returns A Shiny server module.
#' @describeIn module_star_systems Server function for the module.
#' @export
star_systems_server = function(id, data) {
  shiny::moduleServer(id, function(input, output, session) {
    logger::log_trace("{id} initialized.")

    star_system_data = shiny::reactive({
      shiny::req(data())
      data() |> trim_ps_table()
    })

    available_stars = shiny::reactive({
      star_system_data() |>
        dplyr::pull(hostname) |>
        unique() |>
        sort()
    })

    selected_star = search_server(
      "search_star_systems",
      choices = available_stars,
      start_random = TRUE
    )

    system_data = shiny::reactive({
      shiny::req(selected_star())
      star_system_data() |>
        dplyr::filter(hostname == selected_star())
    })

    available_planets = shiny::reactive({
      system_data() |>
        dplyr::pull(pl_name) |>
        unique() |>
        sort()
    })

    selected_planet = search_server(
      "search_planets",
      choices = available_planets,
      start_random = TRUE
    )

    planet_data = shiny::reactive({
      shiny::req(selected_planet())
      system_data() |>
        dplyr::filter(pl_name == selected_planet())
    })

    plot_options = system_plot_settings_server("system_plot_settings")
    visualize_star_system_server(
      "visualize_star_systems",
      plot_data = system_data,
      show_hz = shiny::reactive(plot_options()$show_hz),
      show_legend = shiny::reactive(plot_options()$show_legend)
    )

    system_info = shiny::reactive({
      system_data() %>%
        dplyr::select(hostname, sy_dist, sy_snum, sy_pnum, st_teff, st_rad, st_mass, st_lum) %>%
        dplyr::slice(1) %>%
        dplyr::mutate(st_teff = classify_star_spectral_type(st_teff)) %>%
        dplyr::mutate(dplyr::across(c(sy_dist, st_rad, st_mass, st_lum), ~ round(.x, 3))) %>%
        dplyr::rename("Stellar spectral class" = st_teff) %>%
        dplyr::rename(any_of(exoplanets_col_labels[["pscomppars"]]))
    })

    planet_info = shiny::reactive(planet_data() %>%
      dplyr::select(
        pl_name, objectid, disc_year, discoverymethod,
        pl_rade, pl_bmasse, pl_insol, pl_dens,
        pl_eqt, pl_orbsmax, pl_orbper, pl_orbeccen
      ) %>%
      mutate(
        dplyr::across(c(
          pl_rade, pl_bmasse, pl_insol, pl_dens,
          pl_eqt, pl_orbsmax, pl_orbper, pl_orbeccen
        ),
        ~ round(.x, 3))
      ) %>%
      dplyr::rename(dplyr::any_of(exoplanets_col_labels[["pscomppars"]]))
    )

    system_info_server("system_info", system_info)
    planet_details_server("planet_details", planet_info)

    shiny::observe(logger::log_debug("Selected star: {selected_star()}"))
  })
}
