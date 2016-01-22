{-# LANGUAGE RecordWildCards #-}

module ForgetYourPassword.Lib
    ( makePassword
    , PasswordData (..)
    ) where

import           Crypto.Hash
import qualified Data.ByteString.Char8    as C8
import           Data.Char
import           Data.Maybe
import qualified Data.Text                as T
import           Data.Text.Encoding
import           ForgetYourPassword.Model (PasswordData (..))
import           Numeric

makePassword :: PasswordData -> String
makePassword PasswordData{..} = map intToPasswordChar $ (take passwordLength . splitto . hashToInt) makeHash
  where
    intToPasswordChar :: Integer -> Char
    intToPasswordChar i
      | i >= 0 && i <= 9 = chr (48 + fromIntegral i)  -- 0..9
      | i >= 10 && i <= 35 = chr (87 + fromIntegral i)  -- a..z
      | i >= 36 && i <= 61 = chr (29 + fromIntegral i)  -- A..Z
      | otherwise = error "BUG: intToPasswordChar i out of bound"

    splitto :: Integer -> [Integer]
    splitto i = let (q, r) = i `quotRem` 61 in r:splitto q

    hashToInt :: String -> Integer
    hashToInt = fst . head . readHex

    makeHash :: String
    makeHash = C8.unpack $ digestToHexByteString (hash . encodeUtf8 $ T.pack mix :: Digest SHA256)

    mix :: String
    mix = uniqueKey ++ replicate (fromMaybe 1 version) '\xE0031' ++ salt
