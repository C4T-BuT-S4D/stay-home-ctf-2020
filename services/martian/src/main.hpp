#pragma once

//#include "garden.hpp"
//#include "item.hpp"
//#include "home.hpp"
//#include "items_store.hpp"
#include "martian.hpp"
#include "consts.hpp"
#include "utils.hpp"

void Setup( void );
bool Registration( void );
void LoginMenu( void );

bool Login( void );
void Session( void );
void UserMenu( void );


Martian* current_player;


