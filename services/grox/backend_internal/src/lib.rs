#![feature(decl_macro)]
#![feature(proc_macro_hygiene)]

mod api;
mod graph_routes;
mod owner_routes;
pub mod database;

use rocket;
use rocket::config::{Config, Environment};

pub fn create_graph_server() {

    let config = Config::build(Environment::Production)
        .address("0.0.0.0")
        .port(8000)
        .workers(10)
        .finalize();

    rocket::custom(config.unwrap())
        .mount("/api", rocket::routes![
            graph_routes::create_graph,
            graph_routes::create_node,
            graph_routes::create_link,
            graph_routes::get_graph_nodes,
            graph_routes::get_graph_links,
            graph_routes::get_node_links,
            graph_routes::node_exists,
            graph_routes::graph_exists,
            graph_routes::double_linked_nodes
        ])
        .launch();
}

pub fn create_owner_server() {
    let config = Config::build(Environment::Production)
        .address("0.0.0.0")
        .port(8001)
        .workers(10)
        .finalize();

    rocket::custom(config.unwrap())
        .mount("/api", rocket::routes![
            owner_routes::graph_set,
            owner_routes::graph_get,
            owner_routes::node_set,
            owner_routes::node_get,
            owner_routes::node_get_any,
            owner_routes::graph_list
        ])
        .launch();
}