#pragma once

#include "consts.hpp"
#include "item.hpp"
#include "utils.hpp"

class ItemsStore {
	private:
		std::vector<Item> items;
		std::vector<BYTE> FileData;
	public:
		ItemsStore( std::string Filename );
		bool ParseFileData();

		Item GetItemById( int Id );
		Item GetItemByName( std::string Name );

		bool DeleteItemById( int Id );
		bool DeleteItemByName( std::string Name );

		bool InsertItem( Item new_item );
};

extern ItemsStore* storage;