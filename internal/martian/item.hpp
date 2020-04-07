#pragma once

#include "consts.hpp"
#include "utils.hpp"

class Item {
	private:
		double weight;
		DWORD total_count;
		double total_weight;
		
		ITEM_TYPE type;
		std::string name;

		DWORD uid;
	public:
		Item( double, DWORD, ITEM_TYPE, std::string, DWORD );

		double get_weight( void );
		DWORD get_count( void );
		ITEM_TYPE get_type( void );
		std::string get_name( void );
		DWORD get_uid( void );

		void add( DWORD );
		bool del( DWORD );

		void view( void );
};