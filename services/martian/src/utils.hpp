#pragma once 

#include "consts.hpp"

bool CheckUsernameFormat( std::string );
bool CheckPasswordFormat( std::string );
bool CheckUserPassword( std::string, std::string  );

bool FileExist( std::string name );
std::vector<BYTE> ReadFile( std::string filename );
void init_alphs( void );

template <class T> 
bool CheckElementInVector( std::vector<T> vec, T elem );
template <typename T> 
int GetElementId( const std::vector<T>  & TargetVector, const T  & Elem );

std::string GetStrTypeById( ITEM_TYPE _type );
int GetRandomEventId( void );
void Die( void );

bool CheckUserStatus( std::string status );

