use backend_internal;

fn main() -> std::io::Result<()> {
    if let Err(e) = backend_internal::database::init_graph_db() {
        println!("{}", e);
        return Ok(());
    }
    backend_internal::create_graph_server()
}