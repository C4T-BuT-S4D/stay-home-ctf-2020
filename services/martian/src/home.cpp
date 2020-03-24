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
	energy = INIT_ENERGY;
	temperature = INIT_TEMPERATURE;

	storage = new ItemsStore( DEFAULT_ITEMS_FILE_NAME );

	InitDeafultGarden();
	InitDefaultStock();
};

void Home::Damage( double _damage )
{
	health -= _damage;

	if ( health <= 0.0 )
	{
		std::cout << "{-} Your house is completely destroyed!" << std::endl;
		std::cout << "{-} You died!" << std::endl;
		Die();
	}
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
		exit( -1 );
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
	energy -= 0.5;
};
