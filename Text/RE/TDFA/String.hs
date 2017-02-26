{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# OPTIONS_GHC -fno-warn-orphans       #-}
{-# LANGUAGE CPP                        #-}
#if __GLASGOW_HASKELL__ >= 800
{-# OPTIONS_GHC -fno-warn-redundant-constraints #-}
#endif

module Text.RE.TDFA.String
  (
  -- * Tutorial
  -- $tutorial

  -- * The Match Operators
    (*=~)
  , (?=~)
  , (=~)
  , (=~~)
  -- * The Toolkit
  -- $toolkit
  , module Text.RE
  -- * The 'RE' Type
  -- $re
  , module Text.RE.TDFA.RE
  ) where


import           Text.Regex.Base
import           Text.RE
import           Text.RE.Internal.AddCaptureNames
import           Text.RE.TDFA.RE
import qualified Text.Regex.TDFA               as TDFA


-- | find all matches in text
(*=~) :: String
      -> RE
      -> Matches String
(*=~) bs rex = addCaptureNamesToMatches (reCaptureNames rex) $ match (reRegex rex) bs

-- | find first match in text
(?=~) :: String
      -> RE
      -> Match String
(?=~) bs rex = addCaptureNamesToMatch (reCaptureNames rex) $ match (reRegex rex) bs

-- | the regex-base polymorphic match operator
(=~) :: ( RegexContext TDFA.Regex String a
        , RegexMaker   TDFA.Regex TDFA.CompOption TDFA.ExecOption String
        )
     => String
     -> RE
     -> a
(=~) bs rex = match (reRegex rex) bs

-- | the regex-base monadic, polymorphic match operator
(=~~) :: ( Monad m
         , RegexContext TDFA.Regex String a
         , RegexMaker   TDFA.Regex TDFA.CompOption TDFA.ExecOption String
         )
      => String
      -> RE
      -> m a
(=~~) bs rex = matchM (reRegex rex) bs

instance IsRegex RE String where
  matchOnce   = flip (?=~)
  matchMany   = flip (*=~)
  regexSource = reSource

-- $tutorial
-- We have a regex tutorial at <http://tutorial.regex.uk>. These API
-- docs are mainly for reference.

-- $toolkit
--
-- Beyond the above match operators and the regular expression type
-- below, "Text.RE" contains the toolkit for replacing captures,
-- specifying options, etc.

-- $re
--
-- "Text.RE.TDFA.RE" contains the toolkit specific to the 'RE' type,
-- the type generated by the gegex compiler.
