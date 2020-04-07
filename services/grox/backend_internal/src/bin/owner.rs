use backend_internal;

fn main() {
    if let Err(e) = backend_internal::database::init_owner_db() {
        println!("{}", e);
        return;
    }
    backend_internal::create_owner_server();
}