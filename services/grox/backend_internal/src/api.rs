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