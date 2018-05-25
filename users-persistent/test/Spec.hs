{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Users.TestSpec
import Web.Users.Persistent

import System.IO.Temp
import System.IO
import Control.Monad.Logger
import Database.Persist.Sqlite
import Test.Hspec
import qualified Data.Text as T

main :: IO ()
main =
    withSystemTempFile "tempBaseXXX.db" $ \fp hdl ->
    do hClose hdl
       let infoNoFK = set fkEnabled False $ mkSqliteConnectionInfo ""
           wrapper = wrapConnectionInfo infoNoFK sqliteConn
       pool <- runNoLoggingT $ (createSqlPool wrapper 1) (T.pack fp) 5
       hspec $ makeUsersSpec (Persistent $ flip runSqlPool pool)
