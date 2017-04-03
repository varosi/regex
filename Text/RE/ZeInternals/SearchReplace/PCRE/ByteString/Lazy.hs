{-# LANGUAGE CPP                        #-}
#if __GLASGOW_HASKELL__ >= 800
{-# LANGUAGE TemplateHaskellQuotes      #-}
#else
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
#endif

module Text.RE.ZeInternals.SearchReplace.PCRE.ByteString.Lazy
  ( -- * The ed Quasi Quoters
    -- $qq
    ed
  , edMS
  , edMI
  , edBS
  , edBI
  , edMultilineSensitive
  , edMultilineInsensitive
  , edBlockSensitive
  , edBlockInsensitive
  , ed_
  ) where

import qualified Data.ByteString.Lazy.Char8    as LBS
import           Language.Haskell.TH
import           Language.Haskell.TH.Quote
import           Text.RE.REOptions
import           Text.RE.ZeInternals.PCRE
import           Text.RE.ZeInternals.SearchReplace.PCREEdPrime
import           Text.RE.ZeInternals.Types.SearchReplace


ed
  , edMS
  , edMI
  , edBS
  , edBI
  , edMultilineSensitive
  , edMultilineInsensitive
  , edBlockSensitive
  , edBlockInsensitive
  , ed_ :: QuasiQuoter

ed                       = ed' sr_cast $ Just minBound
edMS                     = edMultilineSensitive
edMI                     = edMultilineInsensitive
edBS                     = edBlockSensitive
edBI                     = edBlockInsensitive
edMultilineSensitive     = ed' sr_cast $ Just  MultilineSensitive
edMultilineInsensitive   = ed' sr_cast $ Just  MultilineInsensitive
edBlockSensitive         = ed' sr_cast $ Just  BlockSensitive
edBlockInsensitive       = ed' sr_cast $ Just  BlockInsensitive
ed_                      = ed' fn_cast   Nothing

sr_cast :: Q Exp
sr_cast = [|\x -> x :: SearchReplace RE LBS.ByteString|]

fn_cast :: Q Exp
fn_cast = [|\x -> x :: SimpleREOptions -> SearchReplace RE LBS.ByteString|]

-- $qq
-- The -- | the @[ed| ... \/\/\/ ... |]@ quasi quoters; for exaple,
--
--  @[ed|${y}([0-9]{4})-0*${m}([0-9]{2})-0*${d}([0-9]{2})\/\/\/${d}\/${m}\/${y}|])@
--
-- represents a @SearchReplace@ that will convert a YYYY-MM-DD format date
-- into a DD\/MM\/YYYY format date.
--
-- The only difference betweem these quasi quoters is the RE options that are set:
-- see the "Text.RE.REOptions" documentation for details.
--
