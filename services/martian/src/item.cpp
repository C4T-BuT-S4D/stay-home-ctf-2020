#include "item.hpp"

Item::Item( double _weight, 
	DWORD _count, 
	ITEM_TYPE _type, 
	std::string _name,
	DWORD _uid
)
{
	weight = _weight;
	total_count = _count;
	total_weight = (double)total_count * weight;

	type = _type;

	name = _name;
	uid = _uid;
};

void Item::add( DWORD count )
{
	total_count += count;
	total_weight = (double)total_count * weight;
};

bool Item::del( DWORD count )
{
	if ( count > total_count || total_count == 0 )
	{
		return false;
	}

	total_count -= count;
	total_weight = (double)total_count * weight;
	
	return true;
};

void Item::view( void )
{
	std::cout << "Name: " << name << std::endl;
	std::cout << "Weight: " << total_weight << std::endl;
	std::cout << "Count: " << total_count << std::endl;
	std::cout << "Type: " << GetStrTypeById( type ) << std::endl;
};

DWORD Item::get_uid( void )
{
	return uid;
};

double Item::get_weight( void )
{
	return total_weight;
};

DWORD Item::get_count( void )
{
	return total_count;
};

ITEM_TYPE Item::get_type( void )
{
	return type;
};

std::string Item::get_name( void )
{
	return name;
};