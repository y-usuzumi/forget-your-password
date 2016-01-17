{-# LANGUAGE MultiWayIf        #-}
{-# LANGUAGE OverloadedStrings #-}

import           ForgetYourPassword.Lib
import           Numeric
import           Options.Applicative
import Text.Printf

data Args = Args { passwordData :: PasswordData
                 }

plReader :: ReadM Int
plReader = eitherReader $ \arg ->
  case () of _
              | [(r, "")] <- readDec arg
              , r > 0 && r <= 32 -> return r
              | otherwise -> Left $ "cannot parse value `" ++ arg ++ "'"

argsParser :: Parser Args
argsParser = Args
             <$> (
  PasswordData
  <$> argument str (metavar "unique-key" <> help "Unique key")
  <*> argument str (metavar "salt" <> help "Salt")
  <*> option plReader (
      long "length"
      <> short 'l'
      <> value 8
      <> metavar "password-length"
      <> help "Password length (1 ~ 32; Default is 8)."
      )
  )

announce :: String -> String
announce = printf "Your password is: %s"

-- Main
main :: IO ()
main = do
  args <- execParser (
    info (helper <*> argsParser) (
      fullDesc <> progDesc "Password generator" <> header "Forget Your Password"
      )
    )

  (putStrLn . announce . makePassword . passwordData) args
