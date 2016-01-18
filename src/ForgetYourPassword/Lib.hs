{-# LANGUAGE RecordWildCards #-}

module ForgetYourPassword.Lib
    ( makePassword
    , PasswordData (..)
    ) where

import           Crypto.Hash
import qualified Data.ByteString.Char8 as C8
import           Data.Char
import qualified Data.Text             as T
import           Data.Text.Encoding
import           Numeric

data PasswordData =
  PasswordData { uniqueKey      :: String
               , salt           :: String
               , passwordLength :: {-# UNPACK #-} !Int
               }



makePassword :: PasswordData -> String
makePassword pd@PasswordData{..} = map intToPasswordChar $ take passwordLength $ (splitto . hashToInt . makeHash) pd
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

    makeHash :: PasswordData -> String
    makeHash PasswordData{..} = C8.unpack $ digestToHexByteString (hash . encodeUtf8 $ T.pack (uniqueKey ++ "\xE0031" ++ salt) :: Digest SHA256)
