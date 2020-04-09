use reqwest;
use actix_web::web::{Json, HttpResponse, Path};
use crate::database::get_connection;
use serde_json::json;

use crate::api;

fn error<T: std::fmt::Display>(e: T) -> HttpResponse {
    HttpResponse::Ok().json(json!({
        "error": format!("{}", e)
    }))
}

pub fn graph_set(data: Json<api::GraphSet>) -> HttpResponse {
    let client = get_connection();
    let mut client = match client {
        Ok(c) => c,
        Err(e) => return error(e)
    };

    let url = format!("http://graph:8000/api/graph_exists/{}", data.gid);

    let resp: api::Exists = match reqwest::blocking::get(&url) {
        Ok(data) => match data.json() {
            Ok(data) => data,
            Err(e) => return error(e)
        },
        Err(e) => return error(e)
    };

    if !resp.exists {
        return error("No such graph");
    }

    let result = client.query_one("

    INSERT INTO grapho (uid, gid) VALUES($1, $2) RETURNING id

    ", &[&data.0.uid, &data.0.gid]);

    let id: i32 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    HttpResponse::Ok().json(json!({
        "ok": id
    }))
}

pub fn graph_get(info: Path<(i32, i32)>) -> HttpResponse {
    let (uid, gid) = info.into_inner();
    let client = get_connection();
    let mut client = match client {
        Ok(c) => c,
        Err(e) => return error(e)
    };

    let url = format!("http://graph:8000/api/graph_exists/{}", gid);

    let resp: api::Exists = match reqwest::blocking::get(&url) {
        Ok(data) => match data.json() {
            Ok(data) => data,
            Err(e) => return error(e)
        },
        Err(e) => return error(e)
    };

    if !resp.exists {
        return error("No such graph");
    }

    let result = client.query_one("

    SELECT COUNT(uid) FROM grapho WHERE uid=$1 AND gid=$2

    ", &[&uid, &gid]);

    let id: i64 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    HttpResponse::Ok().json(json!({
        "ok": id
    }))
}

pub fn node_set(data: Json<api::NodeSet>) -> HttpResponse {
    let data = data.into_inner();
    let client = get_connection();
    let mut client = match client {
        Ok(c) => c,
        Err(e) => return error(e)
    };

    let url = format!("http://graph:8000/api/node_exists/{}", data.nid);

    let resp: api::Exists = match reqwest::blocking::get(&url) {
        Ok(data) => match data.json() {
            Ok(data) => data,
            Err(e) => return error(e)
        },
        Err(e) => return error(e)
    };

    if !resp.exists {
        return error("No such node");
    }

    let result = client.query_one("

    INSERT INTO nodeo (uid, nid) VALUES($1, $2) RETURNING id

    ", &[&data.uid, &data.nid]);

    let id: i32 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    HttpResponse::Ok().json(json!({
        "ok": id
    }))
}

pub fn node_get(info: Path<(i32, i32)>) -> HttpResponse {
    let (uid, nid) = info.into_inner();
    let client = get_connection();
    let mut client = match client {
        Ok(c) => c,
        Err(e) => return error(e)
    };

    let url = format!("http://graph:8000/api/node_exists/{}", nid);

    let resp: api::Exists = match reqwest::blocking::get(&url) {
        Ok(data) => match data.json() {
            Ok(data) => data,
            Err(e) => return error(e)
        },
        Err(e) => return error(e)
    };

    if !resp.exists {
        return error("No such node");
    }

    let result = client.query_one("

    SELECT COUNT(uid) FROM nodeo WHERE uid=$1 AND nid=$2

    ", &[&uid, &nid]);

    let id: i64 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    HttpResponse::Ok().json(json!({
        "ok": id
    }))
}

pub fn node_get_any(uid: Path<i32>, data: Json<Vec<i32>>) -> HttpResponse {
    let uid = uid.into_inner();
    let data = data.into_inner();
    let client = get_connection();
    let mut client = match client {
        Ok(c) => c,
        Err(e) => return error(e)
    };

    for nid in &data {
        let url = format!("http://graph:8000/api/node_exists/{}", nid);

        let resp: api::Exists = match reqwest::blocking::get(&url) {
            Ok(data) => match data.json() {
                Ok(data) => data,
                Err(e) => return error(e)
            },
            Err(e) => return error(e)
        };

        if !resp.exists {
            return error("No such node");
        }

    }

    let result = client.query_one("

    SELECT COUNT(uid) FROM nodeo WHERE uid=$1 AND nid=ANY($2)

    ", &[&uid, &data]);

    let id: i64 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    HttpResponse::Ok().json(json!({
        "ok": id
    }))
}

pub fn graph_list(uid: Path<i32>) -> HttpResponse {
    let uid = uid.into_inner();
    let client = get_connection();
    let mut client = match client {
        Ok(c) => c,
        Err(e) => return error(e)
    };

    let result = client.query("

    SELECT gid FROM grapho WHERE uid=$1

    ", &[&uid]);

    let mut graphs: Vec<i32> = Vec::new();

    for row in match result {
        Ok(res) => res,
        Err(e) => return error(e)
    } {
        graphs.push(row.get(0))
    }

    HttpResponse::Ok().json(json!({
        "ok": graphs
    }))
}
