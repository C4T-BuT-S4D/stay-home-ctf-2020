#include "home.hpp"

ItemsStore* storage;

Home::Home( double _health, 
	double _max_capacity, 
	double _energy, 
	double _temperature 
)
{
	health = _health;
	max_capacity = _max_capacity;
	current_capacity = 0;
	is_trophy = false;
	energy = _energy;
	temperature = _temperature;

	storage = new ItemsStore( DEFAULT_ITEMS_FILE_NAME );

	InitDeafultGarden();
	InitDefaultStock();

};

Home::Home()
{
	health = INIT_HP;
	max_capacity = INIT_CAPACITY;
	current_capacity = 0;
	is_trophy = false;
	energy = INIT_ENERGY;
	temperature = INIT_TEMPERATURE;

	storage = new ItemsStore( DEFAULT_ITEMS_FILE_NAME );

	InitDeafultGarden();
	InitDefaultStock();
	// SetTrophy( "test_test_test_testtest_test_test_test" ); // debug only
};

void Home::Damage( double _damage )
{
	if ( _damage < 0.0 )
		_damage = 0.0;
	
	health -= _damage;
};

std::pair<bool,double> Home::Repair( double skill )
{
	std::pair<bool,double> retval( true, 0.0 );

	if ( health != INIT_HP )
	{
		if ( skill < HIGH_REPAIR_SKILL )
		{

			int EventId = GetRandomEventId();
			
			//std::cout << "random = " << EventId << std::endl;

			if ( EventId == HOME_REPAIR_FAIL )
			{
				std::cout << "{-} During the repair, you damaged the energy block";
				std::cout << "and you were shocked." << std::endl;

				std::cout << "Home health -" << ( skill * 2.0 ) << std::endl;
				std::cout << "Home energy -" << 5.0 << std::endl;
				std::cout << "Martian health -" << 10.0 << std::endl;

				health -= ( skill * 2.0 );
				energy -= 5.0;
				
				retval.first = false;
				retval.second = 10.0;

				return retval;
			}

			health += ( skill / 2.0 );

			if ( health > INIT_HP )
				health = INIT_HP;

			std::cout << "{+} The house has been successfully repaired!" << std::endl;

			int changed = 0;

			if ( energy < 85.0 )
			{
				int tmp_scheme[ 8 ];
				std::cout << "{?} Change the power scheme? [y\\n]: ";
				BYTE user_input;
				std::cin >> user_input;

				if ( user_input == 'y' )
				{
					std::string new_scheme( "New scheme is: " );

					std::cout << "{?} for continue enter 1337" << std::endl;

					for ( int i = 0; i < 16; i++ )
					{
						std::cout << "enter new voltage: ";
						scanf( "%d", &tmp_scheme[ i ] );
						changed++;

						if ( tmp_scheme[ i ] == 1337 )
						{
							changed--;
							break;
						}
					}

					std::cout << new_scheme << std::endl;

					for ( int i = 0; i < changed; i++ )
					{
						std::cout << "voltage[" << i << "] = " << tmp_scheme[ i ] << std::endl;
					}
				}

				energy += 10.0;

				if ( energy > INIT_ENERGY )
					energy = INIT_ENERGY;
			}
		}
	}
	else
	{
		std::cout << "{-} House do not require a repair!" << std::endl;
		retval.first = false;
		retval.second = 0.0;

		return retval;
	}

	return retval;
};

void Home::InitDefaultStock( void )
{
	can_add_items = true;

	for ( int i = 0; i < 5; i++ )
	{
		stock.push_back( Item( storage->GetItemById( i ) ) );
		stock[ i ].add( 4 );
		// stock[ i ].view(); // debug view 
	}

	RecalculateStock();
};

bool Home::RecalculateStock( void )
{
	if ( !can_add_items )
		return false;

	double tmp_cap;

	for ( auto item : stock )
	{
		tmp_cap += item.get_weight();
	}

	if ( tmp_cap != current_capacity &&
		 tmp_cap <= max_capacity )
	{
		current_capacity = tmp_cap;
		can_add_items = true;
		return can_add_items;
	}
	else if ( tmp_cap == current_capacity )
	{
		can_add_items = true;
		return can_add_items;
	}
	else
	{
		current_capacity = tmp_cap;
		std::cout << "{-} Stock is overflowed!" << std::endl;
		can_add_items = false;
		return can_add_items;
	}
};

void Home::ViewStockStatus( void )
{
	RecalculateStock();

	std::cout << "-------- Stock --------" << std::endl;
	std::cout << "Max capacity: " << max_capacity << std::endl;
	std::cout << "Current capacity: " << current_capacity << std::endl;
	std::cout << "Overflowed: " << !can_add_items  << std::endl;
};

void Home::ViewStock( void )
{
	int count = 0;

	for ( auto item : stock )
	{
		std::cout << "Item [" << count << "]" << std::endl;
		item.view();
		std::cout << "----------------" << std::endl;

		count++;
	}
};

bool Home::AddItem( Item new_item )
{
	if ( !can_add_items )
	{
		std::cout << "{-} Stock is overflowed! Can't add new items!" << std::endl;
		return false;
	}

	for ( int i = 0; i < stock.size(); i++ )
	{
		if ( stock[ i ].get_name() == new_item.get_name() )
		{
			stock[ i ].add( new_item.get_count() );
			RecalculateStock();
			return true;
		}
	}

	stock.push_back( new_item );

	return false;
};

Item* Home::GetItemByName( std::string ItemName )
{
	for ( int i = 0; i < stock.size(); i++ )
	{
		if ( stock[ i ].get_name() == ItemName )
			return &stock[ i ];
	}

	return NULL;
};

Item* Home::GetItemById( DWORD Id )
{
	if ( Id >= stock.size() )
	{
		std::cout << "{-} Error item id!" << std::endl;
		return NULL;
	}

	return &stock[ Id ];
};

bool Home::MoveToTrashByName( std::string ItemName )
{
	for ( int i = 0; i < stock.size(); i++ )
	{
		if ( stock[ i ].get_name() == ItemName )
		{
			stock.erase( stock.begin() + i );
			return true;
		}
	}

	std::cout << "{-} No such item name!" << std::endl;
	return false;
};

bool Home::MoveToTrashById( DWORD Id )
{
	if ( Id >= stock.size() )
	{
		std::cout << "{-} Internal error! Incorrect item id!" << std::endl;
		exit( 0 );
	}

	stock.erase( stock.begin() + Id );
	return true;
};

int Home::GardenTick( void )
{
	int grown = garden->DailyTick();

	if ( grown > 0 )
	{
		std::cout << "{+} You get <" << grown << "> potatoes from garden!" << std::endl;
		
		Item* potato = GetItemByName( "potato" );

		if ( potato == NULL )
		{
			Item new_patato = storage->GetItemByName( "potato" );
			new_patato.add( grown - 1 );
			AddItem( new_patato );
		}
		else
		{
			potato->add( grown );
		}
	}

	return grown;
};

void Home::InitDeafultGarden()
{
	garden = new Garden( DEFAULT_GARDEN_SIZE );
};

void Home::ViewGarden( void )
{
	garden->ViewGarden();
};

double Home::GetHealth( void )
{
	return health;
};

double Home::GetEnergy( void )
{
	return energy;
};

double Home::GetTemp( void )
{
	return temperature;
};

bool Home::GetStockStatus( void )
{
	return can_add_items;
};

void Home::PlantPotatoes( DWORD count )
{
	garden->PlantPotatoes( count );
};

bool Home::CheckGarden( DWORD count )
{
	DWORD free_cells = garden->GetCountOfFreeBeds();
	return ( free_cells >= count );
};

void Home::EnergyTick( void )
{
	energy -= 5;
};

void Home::SetTrophy( std::string _trophy )
{
	trophy = _trophy;
	is_trophy = true;
};

std::string Home::GetTrophyDisplayCode( void )
{
	std::string display_code;

	void* ptr = (void*) trophy.c_str();
	QWORD x = static_cast<QWORD>( reinterpret_cast<std::uintptr_t>( ptr ) );

	x ^= 0xcafebabedeadbeef;
	x = x >> 1;

	BYTE bytes[ 8 ];

	bytes[ 0 ] = (BYTE) ( x >> 56 );
	bytes[ 1 ] = (BYTE) ( ( x >> 48 ) & 0xff );
	bytes[ 2 ] = (BYTE) ( ( x >> 40 ) & 0xff );
	bytes[ 3 ] = (BYTE) ( ( x >> 32 ) & 0xff );
	bytes[ 4 ] = (BYTE) ( ( x >> 24 ) & 0xff );
	bytes[ 5 ] = (BYTE) ( ( x >> 16 ) & 0xff );
	bytes[ 6 ] = (BYTE) ( ( x >> 8  ) & 0xff );
	bytes[ 7 ] = (BYTE) ( x & 0xff );

	std::swap( bytes[ 0 ], bytes[ 4 ] );
	std::swap( bytes[ 7 ], bytes[ 2 ] );
	std::swap( bytes[ 1 ], bytes[ 3 ] );
	std::swap( bytes[ 5 ], bytes[ 6 ] );

	for ( int i = 0; i < 8; i++ )
	{
		display_code += std::to_string( bytes[ i ] );

		if ( i == 7 )
			continue;

		display_code += "-";
	}

	return display_code;
};

bool Home::TrophyMenu( void )
{
	if ( !is_trophy )
	{
		std::cout << "{-} You have not trophies!" << std::endl;
		return false;
	}

	std::cout << "--- Trophy menu ---" << std::endl;
	std::cout << "1. View" << std::endl;
	std::cout << "2. Recycle" << std::endl;
	std::cout << "3. Remove" << std::endl;
	std::cout << "> ";

	int user_input;
	std::cin >> user_input;

	if ( user_input <= 0 || user_input > 3 )
	{
		std::cout << "{-} Incorrect option!" << std::endl;
		return false;
	}

	switch( user_input )
	{
		case 1:
		{
			ViewTrophy();
			break;
		}
		case 2:
		{
			std::cout << "{?} Enter code from trophy display: ";
			std::string user_code;
			std::cin >> user_code;

			if ( user_code != GetTrophyDisplayCode() )
			{
				std::cout << "{-} Error code! Recycle failed!" << std::endl;
				return false;
			}
			else
			{
				is_trophy = false;
				trophy.clear();

				std::cout << "{+} The trophy was recycled and you got iron <+5>" << std::endl;

				Item add_iron = storage->GetItemByName( "iron" );
				add_iron.add( 4 ); 

				AddItem( add_iron );
			}
		}
		case 3:
		{
			is_trophy = false;
			trophy.clear();
		}
	}

	return true;
};

bool Home::ViewTrophy( void )
{
	int local_var = 1;
	if ( trophy.size() <= 0 || !is_trophy )
	{
		std::cout << "{-} You have no trophies" << std::endl;
		return false;
	}

	std::cout << "{?} Here is a magnificent box with a display, ";
	std::cout << "however, you can’t open it in any way." << std::endl;
	std::cout << "{?} There is no interface to enter." << std::endl;
	std::cout << "{?} Some chars are hardly distinguishable on the display, ";
	std::cout << "but you cannot comprehend their meaning." << std::endl;

	std::cout << "Display code: " << GetTrophyDisplayCode() << std::endl;
	
	return true;
};

bool Home::GetTrophyStatus( void )
{
	return is_trophy;
};