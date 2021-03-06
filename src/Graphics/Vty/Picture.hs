-- Copyright 2009-2010 Corey O'Connor
module Graphics.Vty.Picture ( module Graphics.Vty.Picture
                            , Image
                            , image_width
                            , image_height
                            , (<|>)
                            , (<->)
                            , horiz_cat
                            , vert_cat
                            , background_fill
                            , char
                            , string
                            , iso_10646_string
                            , utf8_string
                            , utf8_bytestring
                            , char_fill
                            , empty_image
                            , translate
                            -- | The possible display attributes used in constructing an `Image`.
                            , module Graphics.Vty.Attributes
                            )
    where

import Graphics.Vty.Attributes
import Graphics.Vty.Image hiding ( attr )

import Data.Word

-- |The type of images to be displayed using 'update'.  
-- Can be constructed directly or using `pic_for_image`. Which provides an initial instance with
-- reasonable defaults for pic_cursor and pic_background.
data Picture = Picture
    { pic_cursor :: Cursor
    , pic_image :: Image 
    , pic_background :: Background
    }

-- | Create a picture for display for the given image. The picture will not have a displayed cursor
-- and the background display attribute will be `current_attr`.
pic_for_image :: Image -> Picture
pic_for_image i = Picture 
    { pic_cursor = NoCursor
    , pic_image = i
    , pic_background = Background ' ' current_attr
    }

-- | A picture can be configured either to not show the cursor or show the cursor at the specified
-- character position. 
--
-- There is not a 1 to 1 map from character positions to a row and column on the screen due to
-- characters that take more than 1 column.
--
-- todo: The Cursor can be given a (character,row) offset outside of the visible bounds of the
-- output region. In this case the cursor will not be shown.
data Cursor = 
      NoCursor
    | Cursor Word Word

-- | Unspecified regions are filled with the picture's background pattern.  The background pattern
-- can specify a character and a display attribute. If the display attribute used previously should
-- be used for a background fill then use `current_attr` for the background attribute. This is the
-- default background display attribute.
--
-- (tofix) The current attribute is always set to the default attributes at the start of updating the
-- screen to a picture.
--
-- (tofix) The background character *must* occupy a single column and no more.  
data Background = Background 
    { background_char :: Char 
    , background_attr :: Attr
    }

