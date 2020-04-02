#![feature(decl_macro)]
#![feature(proc_macro_hygiene)]

mod api;
mod routes;
pub mod database;

use rocket;

pub fn create_server() {
    rocket::ignite()
        .mount("/api", rocket::routes![
            routes::create_graph,
            routes::create_node,
            routes::create_link,
            routes::get_graph_nodes,
            routes::get_graph_links
        ])
        .launch();
}