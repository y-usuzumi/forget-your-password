{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE FlexibleInstances         #-}
{-# LANGUAGE QuasiQuotes               #-}
{-# LANGUAGE TemplateHaskell           #-}
{-# LANGUAGE TypeFamilies              #-}

module ForgetYourPassword.Db ( migrate
                             ) where

import qualified Database.Groundhog.Core as G_C
import qualified Database.Groundhog.Sqlite   as G_S
import qualified Database.Groundhog.TH       as G_TH
import           ForgetYourPassword.Db.Model (Versioning (..))

G_TH.mkPersist G_TH.defaultCodegenConfig [G_TH.groundhog|
- entity: Versioning
  autokey: null
  constructors:
    - name: Versioning
      uniques:
        - name: UniqueConstraint
          fields: [uniqueKey, encSalt]
|]

migrate :: FilePath -> IO ()
migrate fp = G_S.withSqliteConn fp $ G_S.runDbConn $
  G_S.runMigration $
    G_C.migrate (undefined :: Versioning)
