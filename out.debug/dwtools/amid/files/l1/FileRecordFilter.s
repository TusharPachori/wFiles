( function _FileRecordFilter_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../UseBase.s' );

}

//

let _global = _global_;
let _ = _global_.wTools;
let Parent = null;
let Self = function wFileRecordFilter( c )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'FileRecordFilter';

_.assert( !_.FileRecordFilter );
_.assert( !!_.regexpsEscape );

// --
//
// --

function init( o )
{
  let filter = this;

  _.instanceInit( filter );
  Object.preventExtensions( filter );

  if( o )
  {

    // if( o.maskAll )
    // o.maskAll = _.RegexpObject( o.maskAll,'includeAny' );
    // if( o.maskTerminal )
    // o.maskTerminal = _.RegexpObject( o.maskTerminal,'includeAny' );
    // if( o.maskDirectory )
    // o.maskDirectory = _.RegexpObject( o.maskDirectory,'includeAny' );

    filter.copy( o );

  }

  if( filter.hubFileProvider && filter.hubFileProvider.hub && filter.hubFileProvider.hub !== filter.hubFileProvider )
  {
    _.assert( filter.effectiveFileProvider === null || filter.effectiveFileProvider === filter.hubFileProvider );
    filter.effectiveFileProvider = filter.hubFileProvider;
    filter.hubFileProvider = filter.hubFileProvider.hub;
  }

  return filter;
}

//

function TollerantMake( o )
{
  _.assert( arguments.length >= 1, 'Expects at least one argument' );
  _.assert( _.objectIs( Self.prototype.Composes ) );
  o = _.mapsExtend( null, arguments );
  return new Self( _.mapOnly( o, Self.prototype.fieldsOfCopyableGroups ) );
}

//

function And()
{
  _.assert( !_.instanceIs( this ) );

  let dstFilter = null;

  if( arguments.length === 1 )
  return this.Self( arguments[ 0 ] );

  for( let a = 0 ; a < arguments.length ; a++ )
  {
    let srcFilter = arguments[ a ];

    if( dstFilter )
    dstFilter = this.Self( dstFilter );
    if( dstFilter )
    dstFilter.and( srcFilter );
    else
    dstFilter = this.Self( srcFilter );

  }

  return dstFilter;
}

//

function and( src )
{
  let filter = this;

  if( arguments.length > 1 )
  {
    for( let a = 0 ; a < arguments.length ; a++ )
    filter.and( arguments[ a ] );
    return filter;
  }

  if( Config.debug )
  if( src && !( src instanceof filter.Self ) )
  _.assertMapHasOnly( src, filter.fieldsOfCopyableGroups );

  _.assert( _.instanceIs( filter ) );
  _.assert( !filter.formed || filter.formed <= 1 );
  _.assert( !src.formed || src.formed <= 1 );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( src.globMap === null || src.globMap === undefined );
  _.assert( filter.globMap === null );
  _.assert( filter.filterMap === null );
  _.assert( filter.test === null );

  // _.assert( src.inFilePath === null || src.inFilePath === undefined );
  // _.assert( src.basePath === null || src.basePath === undefined );
  // _.assert( filter.inFilePath === null );
  // _.assert( filter.basePath === null );

  // _.assert( !!( filter.hubFileProvider || src.hubFileProvider ) );
  _.assert( !filter.effectiveFileProvider || !src.effectiveFileProvider || filter.effectiveFileProvider === src.effectiveFileProvider );
  _.assert( !filter.hubFileProvider || !src.hubFileProvider || filter.hubFileProvider === src.hubFileProvider );
  _.assert( filter.inFilePath === null );
  _.assert( src.inFilePath === null || src.inFilePath === undefined );

  if( src === filter )
  return filter;

  /* */

  if( src.effectiveFileProvider )
  filter.effectiveFileProvider = src.effectiveFileProvider

  if( src.hubFileProvider )
  filter.hubFileProvider = src.hubFileProvider

  /* */

  // if( src.basePath )
  // {
  //   _.assert( _.strIs( src.basePath ) );
  //   _.assert( filter.basePath === null || _.strIs( filter.basePath ) );
  //   filter.basePath = path.joinIfDefined( filter.basePath, src.basePath );
  // }
  //
  // if( src.prefixPath )
  // filter.prefixPath = path.s.joinIfDefined( filter.prefixPath, src.prefixPath );
  // if( src.postfixPath )
  // filter.postfixPath = path.s.joinIfDefined( filter.postfixPath, src.postfixPath  );

  /* */

  let appending =
  {

    hasExtension : null,
    begins : null,
    ends : null,

  }

  for( let a in appending )
  {
    if( src[ a ] === null || src[ a ] === undefined )
    continue;
    _.assert( _.strIs( src[ a ] ) || _.strsAre( src[ a ] ) );
    _.assert( filter[ a ] === null || _.strIs( filter[ a ] ) || _.strsAre( filter[ a ] ) );
    if( filter[ a ] === null )
    {
      filter[ a ] = src[ a ];
    }
    else
    {
      if( _.strIs( filter[ a ] ) )
      filter[ a ] = [ filter[ a ] ];
      _.arrayAppendOnce( filter[ a ], src[ a ] );
    }
  }

  /* */

  let once =
  {
    notOlder : null,
    notNewer : null,
    notOlderAge : null,
    notNewerAge : null,
  }

  for( let n in once )
  {
    _.assert( !filter[ n ] || !src[ n ], 'Cant "and" filter with another filter, them both have field', n );
    if( src[ n ] )
    filter[ n ] = src[ n ];
  }

  /* */

  filter.maskAll = _.RegexpObject.And( filter.maskAll, src.maskAll || null );
  filter.maskTerminal = _.RegexpObject.And( filter.maskTerminal, src.maskTerminal || null );
  filter.maskDirectory = _.RegexpObject.And( filter.maskDirectory, src.maskDirectory || null );

  filter.maskTransientAll = _.RegexpObject.And( filter.maskTransientAll, src.maskTransientAll || null );
  filter.maskTransientTerminal = _.RegexpObject.And( filter.maskTransientTerminal, src.maskTransientTerminal || null );
  filter.maskTransientDirectory = _.RegexpObject.And( filter.maskTransientDirectory, src.maskTransientDirectory || null );

  return filter;
}

//

function pathsJoin( src )
{
  let filter = this;

  if( arguments.length > 1 )
  {
    for( let a = 0 ; a < arguments.length ; a++ )
    filter.pathsJoin( arguments[ a ] );
    return filter;
  }

  if( Config.debug )
  if( src && !( src instanceof filter.Self ) )
  _.assertMapHasOnly( src, filter.fieldsOfCopyableGroups );

  _.assert( _.instanceIs( filter ) );
  _.assert( !filter.formed || filter.formed <= 1 );
  _.assert( !src.formed || src.formed <= 1 );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( filter.globMap === null );
  _.assert( filter.filterMap === null );
  _.assert( filter.test === null );
  _.assert( filter.inFilePath === null );
  _.assert( !filter.hubFileProvider || !src.hubFileProvider || filter.hubFileProvider === src.hubFileProvider );
  _.assert( src !== filter );
  _.assert( src.globMap === null || src.globMap === undefined );
  _.assert( src.inFilePath === null || src.inFilePath === undefined );

  let fileProvider = filter.effectiveFileProvider || filter.hubFileProvider || src.effectiveFileProvider || src.hubFileProvider;
  let path = fileProvider.path;

  /* */

  if( src.hubFileProvider )
  filter.hubFileProvider = src.hubFileProvider;

  /* */

  // let joining =
  // {
  //   basePath : null,
  //   stemPath : null,
  //   prefixPath : null,
  //   postfixPath : null,
  // }
  //
  // for( let n in joining )
  // if( src[ n ] !== undefined && src[ n ] !== null )
  // {
  //   _.assert( src[ n ] === null || _.strIs( src[ n ] ) );
  //   _.assert( filter[ n ] === null || _.strIs( filter[ n ] ) );
  //   filter[ n ] = path.join( filter[ n ], src.basePath );
  // }

  /* */

  if( src.basePath !== undefined && src.basePath !== null )
  {
    _.assert( src.basePath === null || _.strIs( src.basePath ) );
    _.assert( filter.basePath === null || _.strIs( filter.basePath ) );
    filter.basePath = path.join( filter.basePath, src.basePath );
  }

  if( src.stemPath !== undefined && src.stemPath !== null )
  {
    _.assert( src.stemPath === null || _.strIs( src.stemPath ) || _.arrayIs( src.stemPath ) );
    _.assert( filter.stemPath === null || _.strIs( filter.stemPath ) || _.arrayIs( filter.stemPath ) );
    filter.stemPath = path.join( filter.stemPath, src.stemPath );
  }

  /* */

  let appending =
  {
    prefixPath : null,
    postfixPath : null,
  }

  for( let a in appending )
  {
    if( src[ a ] === null || src[ a ] === undefined )
    continue;

    _.assert( _.strIs( src[ a ] ) || _.strsAre( src[ a ] ) );
    _.assert( filter[ a ] === null || _.strIs( filter[ a ] ) || _.strsAre( filter[ a ] ) );

    if( filter[ a ] === null )
    {
      filter[ a ] = src[ a ];
    }
    else
    {
      if( _.strIs( filter[ a ] ) )
      filter[ a ] = [ filter[ a ] ];
      _.arrayAppendOnce( filter[ a ], src[ a ] );
    }

  }

  return filter;
}

//

function pathsInherit( src )
{
  let filter = this;

  if( arguments.length > 1 )
  {
    for( let a = 0 ; a < arguments.length ; a++ )
    filter.pathsJoin( arguments[ a ] );
    return filter;
  }

  if( Config.debug )
  if( src && !( src instanceof filter.Self ) )
  _.assertMapHasOnly( src, filter.fieldsOfCopyableGroups );

  _.assert( _.instanceIs( filter ) );
  _.assert( !filter.formed || filter.formed <= 1 );
  _.assert( !src.formed || src.formed <= 1 );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( filter.globMap === null );
  _.assert( filter.filterMap === null );
  _.assert( filter.test === null );
  _.assert( filter.inFilePath === null );
  _.assert( !filter.hubFileProvider || !src.hubFileProvider || filter.hubFileProvider === src.hubFileProvider );
  _.assert( src !== filter );
  _.assert( src.globMap === null || src.globMap === undefined );
  _.assert( src.inFilePath === null || src.inFilePath === undefined );

  let fileProvider = filter.effectiveFileProvider || filter.hubFileProvider || src.effectiveFileProvider || src.hubFileProvider;
  let path = fileProvider.path;

  /* */

  if( src.hubFileProvider )
  filter.hubFileProvider = src.hubFileProvider;

  /* */

  let joining =
  {
    basePath : null,
    stemPath : null,
    prefixPath : null,
    postfixPath : null,
  }

  for( let n in joining )
  if( src[ n ] !== undefined && src[ n ] !== null )
  {
    _.assert( src[ n ] === null || _.strIs( src[ n ] ) );
    _.assert( filter[ n ] === null || _.strIs( filter[ n ] ) );
    if( src[ n ] !== null )
    if( filter[ n ] !== null )
    filter[ n ] = path.join( src[ n ], filter[ n ] );
    else
    filter[ n ] = src[ n ];
  }

  /* */

  // if( src.basePath !== undefined && src.basePath !== null )
  // {
  //   _.assert( src.basePath === null || _.strIs( src.basePath ) );
  //   _.assert( filter.basePath === null || _.strIs( filter.basePath ) );
  //   filter.basePath = path.join( filter.basePath, src.basePath );
  // }
  //
  // if( src.stemPath !== undefined && src.stemPath !== null )
  // {
  //   _.assert( src.stemPath === null || _.strIs( src.stemPath ) || _.arrayIs( src.stemPath ) );
  //   _.assert( filter.stemPath === null || _.strIs( filter.stemPath ) || _.arrayIs( filter.stemPath ) );
  //   filter.stemPath = path.join( filter.stemPath, src.stemPath );
  // }

  /* */

  // let appending =
  // {
  //   prefixPath : null,
  //   postfixPath : null,
  // }
  //
  // for( let a in appending )
  // {
  //   if( src[ a ] === null || src[ a ] === undefined )
  //   continue;
  //
  //   _.assert( _.strIs( src[ a ] ) || _.strsAre( src[ a ] ) );
  //   _.assert( filter[ a ] === null || _.strIs( filter[ a ] ) || _.strsAre( filter[ a ] ) );
  //
  //   if( filter[ a ] === null )
  //   {
  //     filter[ a ] = src[ a ];
  //   }
  //   else
  //   {
  //     if( _.strIs( filter[ a ] ) )
  //     filter[ a ] = [ filter[ a ] ];
  //     _.arrayAppendOnce( filter[ a ], src[ a ] );
  //   }
  //
  // }

  return filter;
}

//

function pathsExtend( src )
{
  let filter = this;

  if( arguments.length > 1 )
  {
    for( let a = 0 ; a < arguments.length ; a++ )
    filter.pathsExtend( arguments[ a ] );
    return filter;
  }

  if( Config.debug )
  if( src && !( src instanceof filter.Self ) )
  _.assertMapHasOnly( src, filter.fieldsOfCopyableGroups );

  _.assert( _.instanceIs( filter ) );
  _.assert( !filter.formed || filter.formed <= 1 );
  _.assert( !src.formed || src.formed <= 1 );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( filter.globMap === null );
  _.assert( filter.filterMap === null );
  _.assert( filter.test === null );
  _.assert( filter.inFilePath === null );
  _.assert( !filter.hubFileProvider || !src.hubFileProvider || filter.hubFileProvider === src.hubFileProvider );
  _.assert( src !== filter );
  _.assert( src.globMap === null || src.globMap === undefined );
  _.assert( src.inFilePath === null || src.inFilePath === undefined );

  let fileProvider = filter.effectiveFileProvider || filter.hubFileProvider || src.effectiveFileProvider || src.hubFileProvider;
  let path = fileProvider.path;

  let replacing =
  {

    hubFileProvider : null,
    basePath : null,
    stemPath : null,
    prefixPath : null,
    postfixPath : null,

  }

  /* */

  for( let s in replacing )
  {
    if( src[ s ] === null || src[ s ] === undefined )
    continue;
    filter[ s ] = src[ s ];
  }

  return filter;
}

//

function form()
{
  let filter = this;

  _.assert( filter.formed <= 3 );
  _.assert( filter.hubFileProvider instanceof _.FileProvider.Abstract );

  filter._formFinal();

  _.assert( filter.formed === 5 );
  Object.freeze( filter );
  return filter;
}

//

function _formComponents()
{
  let filter = this;

  _.assert( filter.formed === 0 );

  filter.maskAll = _.RegexpObject( filter.maskAll || Object.create( null ), 'includeAny' );
  filter.maskTerminal = _.RegexpObject( filter.maskTerminal || Object.create( null ), 'includeAny' );
  filter.maskDirectory = _.RegexpObject( filter.maskDirectory || Object.create( null ), 'includeAny' );

  filter.maskTransientAll = _.RegexpObject( filter.maskTransientAll || Object.create( null ), 'includeAny' );
  filter.maskTransientTerminal = _.RegexpObject( filter.maskTransientTerminal || Object.create( null ), 'includeAny' );
  filter.maskTransientDirectory = _.RegexpObject( filter.maskTransientDirectory || Object.create( null ), 'includeAny' );

  filter.formed = 1;
}

//

function _formFixes()
{
  let filter = this;

  if( filter.formed < 1 )
  filter._formComponents();

  let fileProvider = filter.hubFileProvider || filter.effectiveFileProvider;
  let path = fileProvider.path;

  _.assert( arguments.length === 0 );
  _.assert( filter.globMap === null );
  _.assert( filter.formed === 1 );
  _.assert( filter.prefixPath === null || _.strIs( filter.prefixPath ) || _.arrayIs( filter.prefixPath ) );
  _.assert( filter.postfixPath === null || _.strIs( filter.postfixPath ) || _.arrayIs( filter.postfixPath ) );
  _.assert( filter.basePath === null || _.strIs( filter.basePath ) );

  // if( filter.basePath )
  // filter.prefixPath = path.s.join( filter.basePath, filter.prefixPath || '' );
  //
  // filter.postfixPath = filter.postfixPath || '';

  filter.formed = 2;
}

//

function _formBasePath()
{
  let filter = this;

  if( filter.formed === 3 )
  return;
  if( filter.formed < 2 )
  filter._formFixes();

  let fileProvider = filter.hubFileProvider || filter.effectiveFileProvider;
  let path = fileProvider.path;
  // let fixes = _.multipleAll([ filter.prefixPath || '', filter.postfixPath || '' ]);

  _.assert( arguments.length === 0 );
  _.assert( _.objectIs( filter ) );
  _.assert( filter.globMap === null );
  _.assert( filter.formed === 2 );
  _.assert( filter.prefixPath === null || _.strIs( filter.prefixPath ) );
  _.assert( filter.postfixPath === null || _.strIs( filter.postfixPath ) );
  _.assert( filter.basePath === null || _.strIs( filter.basePath ) );
  _.assert( _.strIs( filter.inFilePath ) || _.arrayIs( filter.inFilePath ) || _.mapIs( filter.inFilePath ), 'inFilePath of file record filter is not defined' );

  filter.inFilePath = path.s.normalize( filter.inFilePath );

  // _.assert( filter.prefixPath === null || _.strIs( filter.prefixPath ) || _.arrayIs( filter.prefixPath ) );
  // _.assert( filter.postfixPath === null || _.strIs( filter.postfixPath ) || _.arrayIs( filter.postfixPath ) );

  // filter.globMap = path.s.normalize( path.s.join( fixes[ 0 ], filter.inFilePath || '', fixes[ 1 ] ) );
  // filter.globMap = path.s.normalize( path.s.join( filter.prefixPath || '.', filter.basePath || '.', filter.inFilePath || '.', filter.postfixPath || '.' ) );

  // if( filter.basePath )
  // filter.basePath = path.s.normalize( path.s.join( filter.prefixPath || '.', filter.basePath || '.', filter.postfixPath || '.' ) );

  // debugger;

  filter.globMap = path.s.normalize( path.s.join( filter.prefixPath || '.', filter.inFilePath || '.', filter.postfixPath || '.' ) );
  filter.globMap = path.globMapExtend( null, filter.globMap );

  /* */

  for( let g in filter.globMap )
  {
    let g2 = usePath( g );
    if( g === g2 )
    continue;
    _.assert( _.strIs( g2 ) );
    filter.globMap[ g2 ] = filter.globMap[ g ];
    delete filter.globMap[ g ];
  }

  /* */

  // if( filter.prefixPath )
  // debugger;
  if( filter.basePath === null )
  {
    filter.basePath = _.mapKeys( filter.globMap ).filter( ( g ) => path.isAbsolute( g ) /*|| path.isGlobal( g )*/ );
    filter.basePath = filter.basePath.map( ( g ) => path.fromGlob( g ) );
    _.sure( filter.basePath.length > 0 || ( _.arrayIs( filter.inFilePath ) && filter.inFilePath.length === 0 ), 'Cant deduce basePath' );
    // if( filter.basePath.length > 0 )
    {
      let basePath = Object.create( null );
      for( let b in filter.basePath )
      basePath[ filter.basePath[ b ] ] = path.normalize( filter.basePath[ b ] );
      filter.basePath = basePath;
    }
  }
  else
  {

    _.assert( _.strIs( filter.basePath ) );
    filter.basePath = path.normalize( path.join( filter.prefixPath || '.', filter.basePath, filter.postfixPath || '.' ) );
    filter.basePath = usePath( filter.basePath );
    filter.basePath = path.normalize( filter.basePath );
    let basePath = Object.create( null );
    let stemPath = _.mapKeys( filter.globMap ).filter( ( g ) => path.isAbsolute( g ) );
    stemPath = stemPath.map( ( g ) => path.fromGlob( g ) );
    for( let b in stemPath )
    basePath[ stemPath[ b ] ] = filter.basePath;
    filter.basePath = basePath;

  }

  /* */

  filter.formed = 3;

  if( _.none( path.s.areGlob( filter.globMap ) ) && _.all( _.mapVals( filter.globMap ) ) )
  {
    filter.stemPath = _.mapKeys( filter.globMap );
    if( filter.stemPath.length === 1 )
    filter.stemPath = filter.stemPath[ 0 ];
    filter.globMap = null;
  }

  _.assert
  (
       ( _.arrayIs( filter.stemPath ) && filter.stemPath.length === 0 )
    || ( _.mapIs( filter.basePath ) && _.mapKeys( filter.basePath ).length > 0 )
    , 'Cant deduce base path'
  )

  if( !_.mapKeys( filter.basePath ).length && !filter.effectiveFileProvider )
  filter.effectiveFileProvider = filter.hubFileProvider;

  /* */

  function usePath( path )
  {
    if( filter.effectiveFileProvider && !_.path.isGlobal( path ) )
    return path;
    let effectiveProvider2 = fileProvider.providerForPath( path );
    filter.effectiveFileProvider = filter.effectiveFileProvider || effectiveProvider2;
    _.assert( effectiveProvider2 === null || filter.effectiveFileProvider === effectiveProvider2, 'Record filter should have paths of single file provider' );
    let result = filter.hubFileProvider.localFromGlobal( path );
    return result;
  }

}

//

function _formMasks()
{
  let filter = this;

  if( filter.formed < 3 )
  filter._formBasePath();

  let fileProvider = filter.effectiveFileProvider || filter.hubFileProvider;
  let path = fileProvider.path;

  _.assert( arguments.length === 0 );
  _.assert( filter.formed === 3 );

  /* */

  if( filter.hasExtension )
  {
    _.assert( _.strIs( filter.hasExtension ) || _.strsAre( filter.hasExtension ) );

    filter.hasExtension = _.arrayAs( filter.hasExtension );
    filter.hasExtension = new RegExp( '^.*\\.(' + _.regexpsEscape( filter.hasExtension ).join( '|' ) + ')(\\.|$)(?!.*\/.+)', 'i' );

    filter.maskAll = _.RegexpObject.And( filter.maskAll,{ includeAll : filter.hasExtension } );
    filter.hasExtension = null;
  }

  if( filter.begins )
  {
    _.assert( _.strIs( filter.begins ) || _.strsAre( filter.begins ) );

    filter.begins = _.arrayAs( filter.begins );
    filter.begins = new RegExp( '^(\\.\\/)?(' + _.regexpsEscape( filter.begins ).join( '|' ) + ')' );

    filter.maskAll = _.RegexpObject.And( filter.maskAll,{ includeAll : filter.begins } );
    filter.begins = null;
  }

  if( filter.ends )
  {
    _.assert( _.strIs( filter.ends ) || _.strsAre( filter.ends ) );

    filter.ends = _.arrayAs( filter.ends );
    filter.ends = new RegExp( '(' + '^\.|' + _.regexpsEscape( filter.ends ).join( '|' ) + ')$' );

    filter.maskAll = _.RegexpObject.And( filter.maskAll,{ includeAll : filter.ends } );
    filter.ends = null;
  }

  /* */

  if( filter.globMap )
  {

    for( let g in filter.globMap )
    {

      let value = filter.globMap[ g ];
      if( path.isAbsolute( g ) )
      continue;

      for( let b in filter.basePath )
      {
        let glob = path.join( filter.basePath[ b ], g );
        debugger;
        if( glob !== g )
        {
          delete filter.globMap[ g ];
          path.globMapExtend( filter.globMap, glob, value );
        }
      }

    }

    _.assert( filter.filterMap === null );
    filter.filterMap = Object.create( null );
    filter._processed = path.globMapToRegexps( filter.globMap, filter.basePath  );

    _.assert( filter.stemPath === null );
    filter.stemPath = _.mapKeys( filter._processed.regexpMap );
    // debugger;
    for( let p in filter._processed.regexpMap )
    {
      let basePath = filter.basePath[ p ];
      _.assert( _.strDefined( basePath ), 'No base path for', p );
      let relative = p;
      let regexps = filter._processed.regexpMap[ p ];
      _.assert( !filter.filterMap[ relative ] );
      let subfilter = filter.filterMap[ relative ] = Object.create( null );
      subfilter.maskAll = _.RegexpObject.And( filter.maskAll.clone(), { includeAny : regexps.actual, excludeAny : regexps.notActual } );
      subfilter.maskTerminal = filter.maskTerminal.clone();
      subfilter.maskDirectory = filter.maskDirectory.clone();
      subfilter.maskTransientAll = filter.maskTransientAll.clone();
      subfilter.maskTransientTerminal = _.RegexpObject.And( filter.maskTransientTerminal.clone(), { includeAny : /$_^/ } );
      subfilter.maskTransientDirectory = _.RegexpObject.And( filter.maskTransientDirectory.clone(), { includeAny : regexps.transient } );
      _.assert( subfilter.maskAll !== filter.maskAll );
    }

  }

  /* */

  if( Config.debug )
  {

    if( filter.notOlder )
    _.assert( _.numberIs( filter.notOlder ) || _.dateIs( filter.notOlder ) );

    if( filter.notNewer )
    _.assert( _.numberIs( filter.notNewer ) || _.dateIs( filter.notNewer ) );

    if( filter.notOlderAge )
    _.assert( _.numberIs( filter.notOlderAge ) || _.dateIs( filter.notOlderAge )  );

    if( filter.notNewerAge )
    _.assert( _.numberIs( filter.notNewerAge ) || _.dateIs( filter.notNewerAge ) );

  }

  filter.formed = 4;
}

//

function _formFinal()
{
  let filter = this;

  if( filter.formed < 4 )
  filter._formMasks();

  let fileProvider = filter.hubFileProvider;
  let path = fileProvider.path;

  _.assert( arguments.length === 0 );
  _.assert( filter.formed === 4 );
  _.assert( _.strIs( filter.stemPath ) || _.arrayIs( filter.stemPath ) );
  _.assert( path.s.noneAreGlob( filter.stemPath ) );
  _.assert( path.s.allAreAbsolute( filter.stemPath ) || path.s.allAreGlobal( filter.stemPath ) );
  _.assert( _.objectIs( filter.basePath ) );
  _.assert( /*!_.mapKeys( filter.basePath ).length ||*/ _.objectIs( filter.effectiveFileProvider ) );
  _.assert( _.objectIs( filter.hubFileProvider ) );

  for( let p in filter.basePath )
  {
    let stemPath = p;
    let basePath = filter.basePath[ p ];
    _.assert
    (
      path.isAbsolute( stemPath ) && path.isNormalized( stemPath ) && !path.isGlob( stemPath ) && !path.isTrailed( stemPath ),
      () => 'Stem path should be absolute and normalized, but not glob, neither trailed' + '\nstemPath : ' + _.toStr( stemPath )
    );
    _.assert
    (
      path.isAbsolute( basePath ) && path.isNormalized( basePath ) && !path.isGlob( basePath ) && !path.isTrailed( basePath ),
      () => 'Base path should be absolute and normalized, but not glob, neither trailed' + '\nbasePath : ' + _.toStr( basePath )
    );
  }

  // if( _.arrayIs( filter.stemPath ) && filter.stemPath.length === 1 )
  // filter.stemPath = filter.stemPath[ 0 ];

  filter.test = filter._testNothing;

  if( filter.notOlder || filter.notNewer || filter.notOlderAge || filter.notNewerAge )
  filter.test = filter._testFull;
  else if( filter.hasMask() )
  filter.test = filter._testMasks;

  filter.formed = 5;
}

//

function determineEffectiveFileProvider( filePath )
{
  let filter = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( filter.effectiveFileProvider )
  return filter.effectiveFileProvider;

  if( !filePath )
  filePath = filter.stemPath;

  if( !filePath )
  filePath = filter.inFilePath;

  if( !filePath )
  filePath = filter.basePath

  _.assert( _.strIs( filePath ) );

  let fileProvider = filter.hubFileProvider;
  filter.effectiveFileProvider = fileProvider.providerForPath( filePath );

  // function usePath( path )
  // {
  //   if( filter.effectiveFileProvider && !_.path.isGlobal( path ) )
  //   return path;
  //   let effectiveProvider2 = fileProvider.providerForPath( path );
  //   filter.effectiveFileProvider = filter.effectiveFileProvider || effectiveProvider2;
  //   _.assert( effectiveProvider2 === null || filter.effectiveFileProvider === effectiveProvider2, 'Record filter should have paths of single file provider' );
  //   let result = filter.hubFileProvider.localFromGlobal( path );
  //   return result;
  // }

  return filter.effectiveFileProvider;
}

//

function filteringEmpty()
{
  let filter = this;

  filter.maskAll = null;
  filter.maskTerminal = null;
  filter.maskDirectory = null;
  filter.maskTransientAll = null;
  filter.maskTransientTerminal = null;
  filter.maskTransientDirectory = null;

  filter.hasExtension = null;
  filter.begins = null;
  filter.ends = null;

  filter.notOlder = null;
  filter.notNewer = null;
  filter.notOlderAge = null;
  filter.notNewerAge = null;

  return filter;
}

//

function hasMask()
{
  let filter = this;

  if( filter.filterMap )
  return true;

  let hasMask = false;

  hasMask = hasMask || ( filter.maskAll && !filter.maskAll.isEmpty() );
  hasMask = hasMask || ( filter.maskTerminal && !filter.maskTerminal.isEmpty() );
  hasMask = hasMask || ( filter.maskDirectory && !filter.maskDirectory.isEmpty() );
  hasMask = hasMask || ( filter.maskTransientAll && !filter.maskTransientAll.isEmpty() );
  hasMask = hasMask || ( filter.maskTransientTerminal && !filter.maskTransientTerminal.isEmpty() );
  hasMask = hasMask || ( filter.maskTransientDirectory && !filter.maskTransientDirectory.isEmpty() );

  hasMask = hasMask || !!filter.hasExtension;
  hasMask = hasMask || !!filter.begins;
  hasMask = hasMask || !!filter.ends;

  return hasMask;
}

//

function hasFiltering()
{
  let filter = this;

  if( filter.hasMask() )
  return true;

  if( filter.notOlder !== null )
  return true;
  if( filter.notNewer !== null )
  return true;
  if( filter.notOlderAge !== null )
  return true;
  if( filter.notNewerAge !== null )
  return true;

  return false;
}

//

function hasData()
{
  let filter = this;

  _.assert( filter.basePath === null || _.strIs( filter.basePath ) || _.mapIs( filter.basePath ) );
  _.assert( filter.prefixPath === null || _.strIs( filter.prefixPath ) );
  _.assert( filter.postfixPath === null || _.strIs( filter.postfixPath ) );
  _.assert( filter.stemPath === null || _.strIs( filter.stemPath ) || _.arrayIs( filter.stemPath ) );
  _.assert( filter.inFilePath === null || _.strIs( filter.inFilePath ) || _.arrayIs( filter.inFilePath ) || _.mapIs( filter.inFilePath ) );

  if( _.strIs( filter.basePath ) || _.mapIsPopulated( filter.basePath ) )
  return true;

  if( _.strIs( filter.prefixPath ) )
  return true;

  if( _.strIs( filter.postfixPath ) )
  return true;

  if( _.strIs( filter.stemPath ) || _.arrayIsPopulated( filter.stemPath ) )
  return true;

  if( _.strIs( filter.inFilePath ) || _.arrayIsPopulated( filter.inFilePath ) || _.mapIsPopulated( filter.inFilePath ) )
  return true;

  return filter.hasFiltering();
}

//

function compactField( it )
{
  let filter = this;

  if( it.dst === null )
  return;

  // debugger;

  if( it.dst && it.dst instanceof _.RegexpObject )
  if( !it.dst.hasData() )
  return;

  if( _.objectIs( it.dst ) && _.mapKeys( it.dst ).length === 0 )
  return;

  return it.dst;
}

//

function toStr()
{
  let filter = this;
  let result = '';

  // _.assert( arguments.length === 0 );

  result += 'Filter';

  for( let m in filter.MaskNames )
  {
    let maskName = filter.MaskNames[ m ];
    if( filter[ maskName ] !== null && !filter[ maskName ].isEmpty() )
    result += '\n' + '  ' + maskName + ' : ' + !filter[ maskName ].isEmpty();
  }

  let FieldNames =
  [
    'basePath',
    'prefixPath', 'postfixPath', 'stemPath',
    'hasExtension', 'begins', 'ends',
    'notOlder', 'notNewer', 'notOlderAge', 'notNewerAge',
  ];

  for( let f in FieldNames )
  {
    let fieldName = FieldNames[ f ];
    if( filter[ fieldName ] !== null )
    result += '\n' + '  ' + fieldName + ' : ' + _.toStr( filter[ fieldName ] );
  }

  return result;
}

//

function _testNothing( record )
{
  let filter = this;
  return record.isActual;
}

//

function _testMasks( record )
{
  let filter = this;
  let relative = record.relative;
  let c = record.context;
  let path = record.path;
  filter = filter.filterMap ? filter.filterMap[ c.stemPath ] : filter;
  // let filter = filter.filterMap ? filter.filterMap[ path.relative( c.basePath, c.stemPath ) ] : filter;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( !!filter, 'Cant resolve filter for start path', () => _.strQuote( c.stemPath ) );
  _.assert( c.formed, 'Record context was not formed!' );

  // debugger;
  // if( record.absolute === '/dst/file2' )
  // debugger;
  // if( _.strHas( record.absolute, 'layer1' ) )
  // debugger;
  // if( _.strEnds( record.absolute, 'layer1' ) )
  // debugger;

  /* */

  if( record.isDir )
  {

    if( record.isTransient && filter.maskTransientAll )
    record.isTransient = filter.maskTransientAll.test( relative );
    if( record.isTransient && filter.maskTransientDirectory )
    record.isTransient = filter.maskTransientDirectory.test( relative );

    if( record.isActual && filter.maskAll )
    record.isActual = filter.maskAll.test( relative );
    if( record.isActual && filter.maskDirectory )
    record.isActual = filter.maskDirectory.test( relative );

  }
  else
  {

    if( record.isActual && filter.maskAll )
    record.isActual = filter.maskAll.test( relative );
    if( record.isActual && filter.maskTerminal )
    record.isActual = filter.maskTerminal.test( relative );

    if( record.isTransient && filter.maskTransientAll )
    record.isTransient = filter.maskTransientAll.test( relative );
    if( record.isTransient && filter.maskTransientTerminal )
    record.isTransient = filter.maskTransientTerminal.test( relative );

  }

  /* */

  // logger.log( '_testMasks', record.absolute, record.isTransient, record.isActual );
  // if( record.absolute === '/common.external' )
  // debugger;
  // if( _.strHas( record.absolute, '/dstExt/d1a/d1b/b.js' ) )
  // debugger;
  // if( _.strHas( record.absolute, '/doubledir/d1/b' ) )
  // debugger;
  // if( _.strHas( record.absolute, '.im.in.yml' ) )
  // debugger;

  return record.isActual;
}

//

function _testTime( record )
{
  let filter = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( record.isActual === false )
  return record.isActual;

  if( !record.isDir )
  {
    let time;
    if( record.isActual === true )
    {
      time = record.stat.mtime;
      if( record.stat.birthtime > record.stat.mtime )
      time = record.stat.birthtime;
    }

    if( record.isActual === true )
    if( filter.notOlder !== null )
    {
      debugger;
      record.isActual = time >= filter.notOlder;
    }

    if( record.isActual === true )
    if( filter.notNewer !== null )
    {
      debugger;
      record.isActual = time <= filter.notNewer;
    }

    if( record.isActual === true )
    if( filter.notOlderAge !== null )
    {
      debugger;
      record.isActual = _.timeNow() - filter.notOlderAge - time <= 0;
    }

    if( record.isActual === true )
    if( filter.notNewerAge !== null )
    {
      debugger;
      record.isActual = _.timeNow() - filter.notNewerAge - time >= 0;
    }
  }

  return record.isActual;
}

//

function _testFull( record )
{
  let filter = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( record.isActual === false )
  return record.isActual;

  filter._testMasks( record );
  filter._testTime( record );

  return record.isActual;
}

// --
// accessors
// --

function basePathsGet()
{
  let filter = this;

  _.assert( arguments.length === 0 );
  _.assert( filter.basePath === null || _.strIs( filter.basePath ) || _.mapIs( filter.basePath ) );

  if( _.objectIs( filter.basePath ) )
  return _.arrayUnique( _.mapVals( filter.basePath ) )
  else if( _.strIs( filter.basePath ) )
  return [ filter.basePath ];
  else
  return [];
}

// --
// relations
// --

let MaskNames =
[
  'maskAll',
  'maskTerminal',
  'maskDirectory',
  'maskTransientAll',
  'maskTransientTerminal',
  'maskTransientDirectory',
]

let Composes =
{

  hasExtension : null,
  begins : null,
  ends : null,

  maskTransientAll : null,
  maskTransientTerminal : null,
  maskTransientDirectory : null,
  maskAll : null,
  maskTerminal : null,
  maskDirectory : null,

  notOlder : null,
  notNewer : null,
  notOlderAge : null,
  notNewerAge : null,

  basePath : null,
  prefixPath : null,
  postfixPath : null,

}

let Aggregates =
{

  inFilePath : null,
  stemPath : null,

}

let Associates =
{
  effectiveFileProvider : null,
  hubFileProvider : null,
}

let Restricts =
{

  globMap : null,
  filterMap : null,
  test : null,
  formed : 0,
  _processed : null,

}

let Statics =
{
  TollerantMake : TollerantMake,
  And : And,
  MaskNames : MaskNames,
}

let Globals =
{
}

let Forbids =
{

  options : 'options',
  glob : 'glob',
  recipe : 'recipe',
  filePath : 'filePath',
  globOut : 'globOut',
  inPrefixPath : 'inPrefixPath',
  inPostfixPath : 'inPostfixPath',
  fixedFilePath : 'fixedFilePath',
  fileProvider : 'fileProvider',
  fileProviderEffective : 'fileProviderEffective',
  isEmpty : 'isEmpty',

}

let Accessors =
{
  basePaths : { getter : basePathsGet, readOnly : 1 },
}

// --
// declare
// --

let Proto =
{

  init : init,

  TollerantMake : TollerantMake,
  And : And,
  and : and,
  pathsJoin : pathsJoin,
  pathsInherit : pathsInherit,
  pathsExtend : pathsExtend,

  form : form,
  _formComponents : _formComponents,
  _formFixes : _formFixes,
  _formBasePath : _formBasePath,
  _formMasks : _formMasks,
  _formFinal : _formFinal,

  determineEffectiveFileProvider : determineEffectiveFileProvider,

  filteringEmpty : filteringEmpty,
  hasMask : hasMask,
  hasFiltering : hasFiltering,
  hasData : hasData,
  compactField : compactField,
  toStr : toStr,

  _testNothing : _testNothing,
  _testMasks : _testMasks,
  _testTime : _testTime,
  _testFull : _testFull,

  // accessor

  basePathsGet : basePathsGet,

  //

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,
  Forbids : Forbids,
  Accessors : Accessors,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.mapExtend( _,Globals );

if( _global_.wCopyable )
_.Copyable.mixin( Self );

// --
// export
// --

_[ Self.shortName ] = Self;

// if( typeof module !== 'undefined' )
// if( _global_.WTOOLS_PRIVATE )
// { /* delete require.cache[ module.id ]; */ }

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();