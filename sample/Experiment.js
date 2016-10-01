if( typeof module !== 'undefined' )
{
  // require( '../../wTools/staging/abase/wTools.s' )
  require( 'wTools' )
  require( '../staging/amid/file/Files.ss' )
  require( '../staging/amid/file/FileProviderSimpleStructure.s' )

}

var _ = wTools;

var tree =
{
 "folder.abc" :
 {
   'test1.js' : "test\n.gitignore\n.travis.yml\nMakefile\nexample.js\n",
   'test2' : "var concatMap = require('concat-map');\nvar balanced = require('balanced-match');",
   'folder2.x' :
   {
     'test1.txt' : "var concatMap = require('concat-map');\nvar balanced = require('balanced-match');",
   }
 }
}

var files = _.FileProvider.SimpleStructure( { tree : tree } );
var consequence = files.fileReadAct( { pathFile : '/folder.abc/folder2.x/test1.txt' } );

consequence.then_( function( err,data )
{

  console.log( '\nfiles.fileReadAct :' );

  if( err )
  throw _.err( err );
  else
  console.log( data );

});

var data = files.fileReadAct( { pathFile : '/folder.abc/folder2.x/test1.txt', sync : 1 } );
console.log('\nfiles.fileReadAct, syncronous : ', data );
