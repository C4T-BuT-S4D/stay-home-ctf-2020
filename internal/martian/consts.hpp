#pragma once 

#include <iostream>
#include <vector>
#include <algorithm>
#include <fstream>
#include <time.h>
#include <cstdio>
#include <cstring>

#include <sys/stat.h>
#include <unistd.h>
#include <string>
#include <iterator>

#include <random>

// c++ 17 
#include <filesystem>


#define USER_STORAGE_PREFIX "users/"
#define DEFAULT_ITEMS_FILE_NAME "items.txt"

#define INIT_HP 100.0
#define INIT_HUNGER 0.5
#define INIT_THIRST 0.5
#define INIT_STAMINA 70.0
#define INIT_INTELLIGENCE 10.0
#define INIT_REPAIR_SKILL 5.0	

#define INIT_SPEED 150.0
#define INIT_CAPACITY 550.0

#define INIT_ENERGY 100.0
#define INIT_TEMPERATURE 23.0

#define TMP_BUF_SIZE 128
#define INIT_ACTIONS_POINTS 24
#define DEFAULT_GARDEN_SIZE 5
#define DAYS_BEFORE_HARVEST 6

#define HIGH_REPAIR_SKILL 10.0

typedef unsigned long long QWORD;
typedef unsigned int DWORD;
typedef unsigned short int WORD;
typedef unsigned char BYTE;

enum ITEM_TYPE { Material, 
	Food, 
	Drink, 
	Armor 
};

enum ACTION_TYPE { 
	READ_BOOK = 1, 
	PLANT_POTATOES = 6, 
	MAKE_EASY_RAID = 3, 
	MAKE_MEDIUM_RAID = 6, 
	MAKE_HARD_RAID = 9, 
	REPAIR_HOME = 3 
};

enum EVENTS {
	HOME_REPAIR_FAIL = 7,
	NIGHT_DESTINY = 42,
	NIGHT_INT_IS_POWER = 90,
	NIGHT_CHOKED = 13
};


