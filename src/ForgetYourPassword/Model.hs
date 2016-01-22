module ForgetYourPassword.Model ( PasswordData (..)
                                ) where

data PasswordData = PasswordData { uniqueKey      :: !String
                                 , salt           :: !String
                                 , version        :: !(Maybe Int)
                                 , passwordLength :: {-# UNPACK #-} !Int
                                 } deriving Show
