CREATE EXTENSION "uuid-ossp";

create table objects (
  id uuid default uuid_generate_v4() PRIMARY KEY,

  -- current object position
  position point,

  -- current object velocity
  velocity point,

  -- current object mass
  mass float,

  -- narrow-beam antenna parameters
  antenna_a float,
  antenna_b float,

  -- narrow-beam message pong
  narrow_beam_response varchar(500),

  -- creation time
  created_at timestamp with time zone default now(),

  -- last computation time
  refreshed_at timestamp with time zone default now()
);

insert into objects
  (id, position, velocity, mass, narrow_beam_response, antenna_a, antenna_b)
values
  ('a00cb030-4d7b-4e2f-bdfa-bdab27927201', point(0,-10000), point(-3, 0), 100, 'hello', 1000000, 500),
  ('a00cb030-4d7b-4e2f-bdfa-bdab27927202', point(0,10000), point(3, 0), 100, 'world', 1000000, 500);

