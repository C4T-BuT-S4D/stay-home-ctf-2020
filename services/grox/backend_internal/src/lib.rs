#![feature(decl_macro)]
#![feature(proc_macro_hygiene)]

mod api;
mod graph_routes;
mod owner_routes;
pub mod database;

use actix_web::{web, App, HttpServer};

pub fn create_graph_server() -> std::io::Result<()> {
    HttpServer::new(||
        App::new()
            .service(
                web::scope("/api/")
                .route("/create_graph", web::post().to(
                    graph_routes::create_graph
                ))
                .route("/create_node", web::post().to(
                    graph_routes::create_node
                ))
                .route("/link/{l}/{r}", web::get().to(
                    graph_routes::link
                ))
                .route("/graph_nodes/{graph}", web::get().to(
                    graph_routes::graph_nodes
                ))
                .route("/graph_links/{graph}", web::get().to(
                    graph_routes::graph_links
                ))
                .route("/node_links/{node}", web::get().to(
                    graph_routes::node_links
                ))
                .route("/graph_exists/{graph}", web::get().to(
                    graph_routes::graph_exists
                ))
                .route("/node_exists/{node}", web::get().to(
                    graph_routes::node_exists
                ))
                .route("/double_linked_nodes/{node}", web::get().to(
                    graph_routes::double_linked_nodes
                ))
            )
    )
        .workers(10)
        .bind("0.0.0.0:8000")?
        .run().unwrap();

    Ok(())
}

pub fn create_owner_server() -> std::io::Result<()> {
    HttpServer::new(||
        App::new()
            .service(
                web::scope("/api/")
                .route("/graph_set", web::post().to(
                    owner_routes::graph_set
                ))
                .route("/graph_get/{uid}/{gid}", web::get().to(
                    owner_routes::graph_get
                ))
                .route("/node_set", web::post().to(
                    owner_routes::node_set
                ))
                .route("/node_get/{uid}/{nid}", web::get().to(
                    owner_routes::node_get
                ))
                .route("/node_get_any/{uid}", web::post().to(
                    owner_routes::node_get_any
                ))
                .route("/graph_list/{uid}", web::get().to(
                    owner_routes::graph_list
                ))
            )
    )
        .workers(10)
        .bind("0.0.0.0:8001")?
        .run().unwrap();

    Ok(())
}