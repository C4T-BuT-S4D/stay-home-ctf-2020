use reqwest;
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

#[post("/graph_set", data="<data>")]
pub fn graph_set(data: Json<api::GraphSet>) -> JsonValue {
    let data = data.into_inner();
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

    ", &[&data.uid, &data.gid]);

    let id: i32 = match result {
        Ok(row) => row.get(0),
        Err(e) => return error(e)
    };

    json!({
        "ok": id
    })
}

#[get("/graph_get/<uid>/<gid>")]
pub fn graph_get(uid: i32, gid: i32) -> JsonValue {
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

    json!({
        "ok": id
    })
}

#[post("/node_set", data="<data>")]
pub fn node_set(data: Json<api::NodeSet>) -> JsonValue {
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

    json!({
        "ok": id
    })
}

#[get("/node_get/<uid>/<nid>")]
pub fn node_get(uid: i32, nid: i32) -> JsonValue {
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

    json!({
        "ok": id
    })
}

#[post("/node_get_any/<uid>", data="<data>")]
pub fn node_get_any(uid: i32, data: Json<Vec<i32>>) -> JsonValue {
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

    json!({
        "ok": id
    })
}

#[get("/graph_list/<uid>")]
pub fn graph_list(uid: i32) -> JsonValue {
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

    json!({
        "ok": graphs
    })
}
