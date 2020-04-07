use backend_internal;

fn main() {
    if let Err(e) = backend_internal::database::init_graph_db() {
        println!("{}", e);
        return;
    }
    backend_internal::create_graph_server();
}