use rocket::{get, post};
use rocket_contrib::json;
use rocket_contrib::json::{Json, JsonValue};
use crate::database::get_connection;

use crate::api;

fn error<T: std::fmt::Display>(e: T) -> JsonValue {
    json!({
        "error": format!("{}", e)
    })
}

#[post("/create_graph")]
pub fn create_graph() -> JsonValue {
    let client = get_connection();
    let mut client = match client {
        Ok(c) => c,
        Err(e) => return error(e)
    };

    let result = client.query_one("

    INSERT INTO graphs VALUES(DEFAULT) RETURNING id

    ", &[]);

    let id: i32 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    json!({
        "ok": id
    })
}

#[post("/create_node", data="<node>")]
pub fn create_node(node: Json<api::NodeCreate>) -> JsonValue {
    let node = node.into_inner();
    let client = get_connection();
    let mut client = match client {
        Ok(c) => c,
        Err(e) => return error(e)
    };

    let result = client.query_one("

    SELECT COUNT(id) from graphs WHERE id = $1

    ", &[&node.graph]);

    let count: i64 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    if count == 0 {
        return error("No such graph");
    }

    let result = client.query_one("

    INSERT INTO nodes (graph) VALUES($1) RETURNING id

    ", &[&node.graph]);

    let id: i32 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    json!({
        "ok": id
    })
}

#[post("/create_link", data="<link>")]
pub fn create_link(link: Json<api::LinkCreate>) -> JsonValue {
    let link = link.into_inner();
    let client = get_connection();
    let mut client = match client {
        Ok(c) => c,
        Err(e) => return error(e)
    };

    let result = client.query_one("

    SELECT COUNT(id) from nodes WHERE id = $1

    ", &[&link.l]);

    let count: i64 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    if count == 0 {
        return error("No such node l");
    }

    let result = client.query_one("

    SELECT COUNT(id) from nodes WHERE id = $1

    ", &[&link.r]);

    let count: i64 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    if count == 0 {
        return error("No such node r");
    }

    let result = client.query_one("

    INSERT INTO links (l, r) VALUES($1, $2) RETURNING id

    ", &[&link.l, &link.r]);

    let id: i32 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    json!({
        "ok": id
    })
}

#[get("/graph_nodes/<graph>")]
pub fn get_graph_nodes(graph: i32) -> JsonValue {
    let client = get_connection();
    let mut client = match client {
        Ok(c) => c,
        Err(e) => return error(e)
    };

    let result = client.query_one("

    SELECT COUNT(id) from graphs WHERE id = $1

    ", &[&graph]);

    let count: i64 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    if count == 0 {
        return error("No such graph");
    }

    let result = client.query("

    SELECT id FROM nodes WHERE graph=$1

    ", &[&graph]);

    let mut nodes: Vec<i32> = Vec::new();

    for row in match result {
        Ok(res) => res,
        Err(e) => return error(e)
    } {
        nodes.push(row.get(0))
    }

    json!({
        "ok": nodes
    })
}

#[get("/graph_links/<graph>")]
pub fn get_graph_links(graph: i32) -> JsonValue {
    let client = get_connection();
    let mut client = match client {
        Ok(c) => c,
        Err(e) => return error(e)
    };

    let result = client.query_one("

    SELECT COUNT(id) from graphs WHERE id = $1

    ", &[&graph]);

    let count: i64 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    if count == 0 {
        return error("No such graph");
    }

    let result = client.query("

    SELECT DISTINCT ON (L.id) L.id, L.l, L.r FROM links L
    INNER JOIN (
        SELECT id FROM nodes WHERE graph=$1
    ) N
    ON L.l = N.id or L.r = N.id

    ", &[&graph]);

    let mut links: Vec<(i32, i32)> = Vec::new();

    for row in match result {
        Ok(res) => res,
        Err(e) => return error(e)
    } {
        links.push((row.get(0), row.get(1)))
    }

    json!({
        "ok": links
    })
}