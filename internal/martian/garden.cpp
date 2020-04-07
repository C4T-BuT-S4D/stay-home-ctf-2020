#include "garden.hpp"

Garden::Garden( DWORD size )
{
	MaxSize = size;

	for ( int i = 0; i < MaxSize; i++ )
	{
		std::pair<bool,DWORD> cell( false, 0 );
		beds.push_back( cell );
	}

	//ViewGarden(); // debug only 
};

DWORD Garden::GetCountOfFreeBeds( void )
{	
	DWORD freed = 0;

	for ( auto cell : beds )
	{
		if ( !cell.first )
			freed++;
	}

	return freed;
};

bool Garden::PlantPotato( void )
{
	for ( int i = 0; i < beds.size(); i++ )
	{
		if ( !beds[ i ].first )
		{
			beds[ i ].first = true;
			beds[ i ].second = DAYS_BEFORE_HARVEST;
			break;
		}
	}

	return true;
};

bool Garden::PlantPotatoes( DWORD Count )
{
	DWORD freed = GetCountOfFreeBeds();

	if ( Count > freed )
	{
		std::cout << "{-} You don't have enough free cells" << std::endl;
		return false;
	}

	for ( int i = 0; i < Count; i++ )
	{
		PlantPotato();
	}

	return true;
};

void Garden::ViewGarden( void )
{
	std::cout << "---****---- Garden ---****----" << std::endl;

	int count = 0;

	for ( auto cell : beds )
	{
		std::cout << "Cell [" << count++ << "]" << std::endl;
		std::cout << "Status: ";

		if ( cell.first )
		{
			std::cout << "planted" << std::endl;
			std::cout << "Days: " << cell.second << std::endl;
		}
		else
		{
			std::cout << "free" << std::endl;
		}
	}

	std::cout << "---****---****---****---****-" << std::endl;
};

int Garden::DailyTick( void )
{	
	int result = 0;

	for ( int i = 0; i < beds.size(); i++ )
	{
		if ( beds[ i ].first )
		{
			beds[ i ].second -= 1;

			if ( beds[ i ].second == 0 )
			{
				result++;
				beds[ i ].first = false;
			}
		}
	}

	return result * 2;
};