use actix_web::web::{Json, HttpResponse, Path};
use crate::database::get_connection;
use serde_json::json;

use crate::api;

fn error<T: std::fmt::Display>(e: T) -> HttpResponse {
    HttpResponse::Ok().json(json!({
        "error": format!("{}", e)
    }))
}

pub fn create_graph() -> HttpResponse {
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

    HttpResponse::Ok().json(json!({
        "ok": id
    }))
}

pub fn create_node(node: Json<api::NodeCreate>) -> HttpResponse {
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

    HttpResponse::Ok().json(json!({
        "ok": id
    }))
}

pub fn link(info: Path<(i32, i32)>) -> HttpResponse {
    let (l, r) = info.into_inner();
    let client = get_connection();
    let mut client = match client {
        Ok(c) => c,
        Err(e) => return error(e)
    };

    let result = client.query_one("

    SELECT COUNT(id) from nodes WHERE id = $1

    ", &[&l]);

    let count: i64 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    if count == 0 {
        return error("No such node l");
    }

    let result = client.query_one("

    SELECT COUNT(id) from nodes WHERE id = $1

    ", &[&r]);

    let count: i64 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    if count == 0 {
        return error("No such node r");
    }

    let result = client.query_one("

    INSERT INTO links (l, r) VALUES($1, $2) RETURNING id

    ", &[&l, &r]);

    let id: i32 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    HttpResponse::Ok().json(json!({
        "ok": id
    }))
}

pub fn graph_nodes(info: Path<i32>) -> HttpResponse {
    let graph = info.into_inner();
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

    HttpResponse::Ok().json(json!({
        "ok": nodes
    }))
}

pub fn graph_links(info: Path<i32>) -> HttpResponse {
    let graph = info.into_inner();
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

    SELECT id, l, r FROM links L
    WHERE l in (
        SELECT id FROM nodes WHERE graph=$1
    ) and r in (
        SELECT id FROM nodes WHERE graph=$1
    )

    ", &[&graph]);

    let mut links: Vec<(i32, i32, i32)> = Vec::new();

    for row in match result {
        Ok(res) => res,
        Err(e) => return error(e)
    } {
        links.push((row.get(0), row.get(1), row.get(2)))
    }

    HttpResponse::Ok().json(json!({
        "ok": links
    }))
}

pub fn node_links(info: Path<i32>) -> HttpResponse {
    let node = info.into_inner();
    let client = get_connection();
    let mut client = match client {
        Ok(c) => c,
        Err(e) => return error(e)
    };

    let result = client.query_one("

    SELECT COUNT(id) from nodes WHERE id = $1

    ", &[&node]);

    let count: i64 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    if count == 0 {
        return error("No such node");
    }

    let result = client.query("

    SELECT r FROM links WHERE l = $1

    ", &[&node]);

    let mut links: Vec<i32> = Vec::new();

    for row in match result {
        Ok(res) => res,
        Err(e) => return error(e)
    } {
        links.push(row.get(0))
    }

    HttpResponse::Ok().json(json!({
        "ok": links
    }))
}

pub fn graph_exists(info: Path<i32>) -> HttpResponse {
    let graph = info.into_inner();
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
        HttpResponse::Ok().json(json!(api::Exists {
            exists: false
        }))
    } else {
        HttpResponse::Ok().json(json!(api::Exists {
            exists: true
        }))
    }
}

pub fn node_exists(info: Path<i32>) -> HttpResponse {
    let node = info.into_inner();
    let client = get_connection();
    let mut client = match client {
        Ok(c) => c,
        Err(e) => return error(e)
    };

    let result = client.query_one("

    SELECT COUNT(id) from nodes WHERE id = $1

    ", &[&node]);

    let count: i64 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    if count == 0 {
        HttpResponse::Ok().json(json!(api::Exists {
            exists: false
        }))
    } else {
        HttpResponse::Ok().json(json!(api::Exists {
            exists: true
        }))
    }
}

pub fn double_linked_nodes(info: Path<i32>) -> HttpResponse {
    let node = info.into_inner();
    let client = get_connection();
    let mut client = match client {
        Ok(c) => c,
        Err(e) => return error(e)
    };

    let result = client.query("

    SELECT id from nodes N
    WHERE
    EXISTS (SELECT 1 FROM links L1 WHERE L1.l = N.id and L1.r = $1)
    AND
    EXISTS (SELECT 1 FROM links L2 WHERE L2.r = N.id and L2.l = $1)

    ", &[&node]);

    let mut nodes: Vec<i32> = Vec::new();

    for row in match result {
        Ok(res) => res,
        Err(e) => return error(e)
    } {
        nodes.push(row.get(0))
    }

    HttpResponse::Ok().json(json!({
        "ok": nodes
    }))
}