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
  antenna point,

  -- narrow-beam message pong
  narrow_beam_response varchar(500),

  -- creation time
  created_at timestamp with time zone default now(),

  -- last computation time
  refreshed_at timestamp with time zone default now()
);
