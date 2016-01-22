module ForgetYourPassword.Store (
                                ) where

import qualified Database.Groundhog.Core   as G_C
import qualified Database.Groundhog.Sqlite as G_S
import qualified Database.Groundhog.TH     as G_TH
import           ForgetYourPassword.Db
import           ForgetYourPassword.Model  (PasswordData)


lookupPasswordData :: String -> String -> PasswordData
lookupPasswordData = do
  
