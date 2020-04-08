use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct NodeCreate {
    pub graph: i32
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LinkCreate {
    pub l: i32,
    pub r: i32
}

#[derive(Serialize, Deserialize, Debug)]
pub struct GraphSet {
    pub uid: i32,
    pub gid: i32
}

#[derive(Serialize, Deserialize, Debug)]
pub struct NodeSet {
    pub uid: i32,
    pub nid: i32
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Exists {
    pub exists: bool
}
