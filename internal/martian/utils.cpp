#include "utils.hpp"

std::vector<BYTE> digist;
std::vector<BYTE> lowercase;
std::vector<BYTE> uppercase;
std::vector<BYTE> badchars;

bool CheckUsernameFormat( std::string Username )
{
	if ( Username.size() > 16 || Username.size() < 8 ) 
		return false;

	BYTE total_badchars = 0;

	for ( auto chr : Username )
	{
		if ( CheckElementInVector( badchars, (BYTE) chr ) )
			total_badchars++;
	}

	if ( total_badchars != 0 )
		return false;

	return true;
};

bool CheckPasswordFormat( std::string Password )
{
	if ( Password.size() > 16 || Password.size() < 8 ) 
		return false;

	if ( !CheckElementInVector( uppercase, (BYTE) Password[ 0 ] )  )
		return false;

	BYTE total_uppercases = 0;
	BYTE total_lowercases = 0;
	BYTE total_digits = 0;
	BYTE total_badchars = 0;

	for ( auto chr : Password )
	{
		if ( CheckElementInVector( digist, (BYTE) chr ) )
			total_digits++; 

		if ( CheckElementInVector( lowercase, (BYTE) chr ) )
			total_lowercases++;

		if ( CheckElementInVector( uppercase, (BYTE) chr ) )
			total_uppercases++;
	}

	if ( total_digits < 3 || total_uppercases < 3 || total_lowercases < 3 )
		return false;

	if ( total_badchars != 0 )
		return false;

	return true;
};

bool CheckUserPassword( std::string Username, std::string Password )
{
	std::vector<BYTE> UserFileData = ReadFile( USER_STORAGE_PREFIX + 
		Username );

	if ( UserFileData.size() <= 0 )
		return false;

	BYTE password_size = UserFileData[ 0 ];
	
	if ( password_size != Password.size() )
		return false;

	for ( int i = 1; i < ( 1 + password_size ); i++ )
	{
		if ( Password[ i - 1 ] != UserFileData[ i ] )
			return false;
	}

	return true;
};

bool FileExist( std::string name )
{
  struct stat buffer;   
  return ( stat( name.c_str(), &buffer ) == 0 ); 
};

std::vector<BYTE> ReadFile( std::string filename )
{
    std::ifstream file( filename, std::ios::binary );
    file.unsetf( std::ios::skipws );
    std::streampos fileSize;

    file.seekg( 0, std::ios::end );
    fileSize = file.tellg();
    file.seekg( 0, std::ios::beg );

    std::vector<BYTE> vec;
    vec.reserve(fileSize);

    vec.insert( vec.begin(),
               std::istream_iterator<BYTE>( file ),
               std::istream_iterator<BYTE>() );

    return vec;
};

void init_alphs( void )
{
	for ( BYTE i = '0'; i <= '9'; i++ )
		digist.push_back( i );

	for ( BYTE i = 'a'; i <= 'z'; i++ )
		lowercase.push_back( i );

	for ( BYTE i = 'A'; i <= 'Z'; i++ )
		uppercase.push_back( i );

	for ( BYTE i = 0; i < 48; i++ )
		badchars.push_back( i );

	for ( BYTE i = 58; i < 65; i++ )
		badchars.push_back( i );
	
	for ( BYTE i = 91; i < 97; i++ )
		badchars.push_back( i );

	for ( BYTE i = 123; i < 255; i++ )
		badchars.push_back( i );

};

template <class T>
bool CheckElementInVector( std::vector<T> vec, T elem ) 
{
	if ( std::find( vec.begin(), vec.end(), elem ) != vec.end() )
		return true;
	else
		return false;
};

template <typename T>
int GetElementId( const std::vector<T>  & TargetVector, const T  & Elem )
{
	int idx = -1;
	auto it = std::find( TargetVector.begin(), TargetVector.end(), Elem );

	if ( it != TargetVector.end() )
	{
		idx = distance( TargetVector.begin(), it );
	}
	else
	{
		return idx;
	}
};

std::string GetStrTypeById( ITEM_TYPE _type )
{
	switch ( _type )
	{
		case Material:
			return std::string( "Material" );
		case Food:
			return std::string( "Food" );
		case Drink:
			return std::string( "Drink" );
		case Armor:
			return std::string( "Armor" );
		default:
			return std::string( "Undefined" );
	}
};

int GetRandomEventId( void )
{
	std::random_device rd;
	std::mt19937 gen( rd() );
	std::uniform_int_distribution<> dis( 0, 1000 );

	return dis( gen );
};

bool CheckUserStatus( std::string status )
{
	for ( auto chr : status )
	{
		if ( CheckElementInVector( badchars, (BYTE) chr ) && chr != '=' )
			return false;
	}
	
	return true;
};

void Die( std::string username )
{

	std::cout << "{-} You died, your character is deleted!" << std::endl;

	std::string filename( USER_STORAGE_PREFIX );
	filename += username;

	std::remove( filename.c_str() );
	
	exit( 0 );
};
