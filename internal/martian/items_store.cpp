#include "items_store.hpp"

ItemsStore::ItemsStore( std::string Filename )
{
	FileData = ReadFile( Filename );

	if ( FileData.size() <= 0 )
	{
		std::cout << "{-} Items file is empty!" << std::endl;
		exit( 0 );	
	}

	if ( !ParseFileData() ) 
	{
		std::cout << "{-} Error in items-files parsing!" << std::endl;
		exit( 0 );
	}
};

bool ItemsStore::ParseFileData( void )
{
	int lines_count = std::count( FileData.begin(), FileData.end(), '\n' );

	int delimter_count = 0;
	std::string tmp_buf;
	tmp_buf.reserve( 512 );

	int element_id;
	double elemet_weight;
	ITEM_TYPE element_type;
	std::string element_name;

	bool flag;

	// this is shitty code 
	for ( auto byte : FileData )
	{	
		if ( byte == '\n' )
		{
			element_name = tmp_buf;
			tmp_buf.clear();

			// add new item to container
			items.push_back( Item( elemet_weight, 1, element_type, element_name, element_id ) );
			delimter_count = 0;
			continue;
		}
		else
		{	
			if ( byte == '|' )
			{
				flag = true;
				delimter_count++;
			}

			if ( delimter_count == 0 || !flag )
			{
				tmp_buf.push_back( byte );
			}

			else if ( delimter_count == 1 && flag )
			{
				element_id = std::atoi( tmp_buf.c_str() );
				tmp_buf.clear();
				flag = false;
				continue;
			}

			else if ( delimter_count == 2 && flag )
			{
				elemet_weight = std::stod( tmp_buf );
				tmp_buf.clear();
				flag = false;
				continue;
			}

			else if ( delimter_count == 3 && flag )
			{
				if ( tmp_buf == "material" )
					element_type = Material;
				
				else if ( tmp_buf == "drink" )
					element_type = Drink;
				
				else if ( tmp_buf == "food" )
					element_type = Food;

				else if ( tmp_buf == "armor" )
					element_type = Armor;

				tmp_buf.clear();
				flag = false;
				continue;
			}
		}
	}

	return true;
};

Item ItemsStore::GetItemById( int Id )
{
	if ( Id >= items.size() )
	{
		std::cout << "{-} Internal error! Incorrect item id!" << std::endl;
		exit( 0 );
	}

	return items[ Id ];
};

Item ItemsStore::GetItemByName( std::string Name )
{
	for ( auto item : items )
	{
		if ( item.get_name() == Name )
			return item;
	}

	std::cout << "{-} Internal error! Incorrect item name!" << std::endl;
	exit( 0 );
};

bool ItemsStore::DeleteItemById( int Id )
{
	if ( Id >= items.size() )
	{
		std::cout << "{-} Internal error! Incorrect item id!" << std::endl;
		exit( 0 );
	}

	items.erase( items.begin() + Id );

	return true;
};

bool ItemsStore::DeleteItemByName( std::string Name )
{
	for ( int i = 0; i < items.size(); i++ )
	{
		if ( items[ i ].get_name() == Name )
		{
			items.erase( items.begin() + i );
			return true;
		}
	}

	std::cout << "{-} Internal error! Incorrect item name!" << std::endl;
	exit( 0 );

	return true;
};

bool ItemsStore::InsertItem( Item new_item )
{
	for ( auto item : items )
	{
		if ( item.get_name() == new_item.get_name() )
		{
			std::cout << "{-} Item with same name already exist!" << std::endl;
			return false;
		}
	}

	items.push_back( new_item );

	return true;
};
