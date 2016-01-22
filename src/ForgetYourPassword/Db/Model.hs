module ForgetYourPassword.Db.Model
       ( Versioning (..)
       ) where

data Versioning = Versioning { uniqueKey :: !String
                             , encSalt :: !String
                             , version :: !Int
                             } deriving Show
