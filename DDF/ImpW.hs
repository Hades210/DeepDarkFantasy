{-# LANGUAGE
  NoImplicitPrelude,
  RankNTypes,
  InstanceSigs,
  ScopedTypeVariables,
  ExistentialQuantification,
  TypeFamilies,
  TypeApplications,
  FlexibleInstances,
  MultiParamTypeClasses
#-}

module DDF.ImpW where

import DDF.Lang
import qualified DDF.Map as Map
import qualified DDF.VectorTF as VTF

runImpW :: forall r h x. Unit r => ImpW r h x -> RunImpW r h x
runImpW (ImpW x) = RunImpW x
runImpW (NoImpW x) = RunImpW (const1 x :: r h (() -> x))

instance Prod r => DBI (ImpW r) where
  z = NoImpW z
  s :: forall a h b. ImpW r h b -> ImpW r (a, h) b
  s (ImpW w) = ImpW (s w)
  s (NoImpW x) = NoImpW (s x)
  app (ImpW f) (ImpW x) = ImpW (lam $ \p -> app (app (conv f) (zro1 p)) (app (conv x) (fst1 p)))
  app (NoImpW f) (NoImpW x) = NoImpW (app f x)
  app (ImpW f) (NoImpW x) = ImpW (lam $ \w -> app2 (conv f) w (conv x))
  app (NoImpW f) (ImpW x) = ImpW (lam $ \w -> app (conv f) (app (conv x) w))
  abs (ImpW f) = ImpW (flip1 $ abs f)
  abs (NoImpW x) = NoImpW (abs x)
  liftEnv (NoImpW x) = NoImpW $ liftEnv x
  liftEnv (ImpW x) = ImpW $ liftEnv x

instance (Prod r, Bool r) => Bool (ImpW r) where
  bool = NoImpW . bool
  ite = NoImpW ite

instance (Prod r, Char r) => Char (ImpW r) where
  char = NoImpW . char

instance Prod r => Prod (ImpW r) where
  mkProd = NoImpW mkProd
  zro = NoImpW zro
  fst = NoImpW fst
  
instance (Prod r, Double r) => Double (ImpW r) where
  double = NoImpW . double
  doubleExp = NoImpW doubleExp
  doublePlus = NoImpW doublePlus
  doubleMinus = NoImpW doubleMinus
  doubleMult = NoImpW doubleMult
  doubleDivide = NoImpW doubleDivide

instance (Prod r, Float r) => Float (ImpW r) where
  float = NoImpW . float
  floatExp = NoImpW floatExp
  floatPlus = NoImpW floatPlus
  floatMinus = NoImpW floatMinus
  floatMult = NoImpW floatMult
  floatDivide = NoImpW floatDivide

instance (Prod r, Option r) => Option (ImpW r) where
  nothing = NoImpW nothing
  just = NoImpW just
  optionMatch = NoImpW optionMatch

instance Map.Map r => Map.Map (ImpW r) where
  empty = NoImpW Map.empty
  singleton = NoImpW Map.singleton
  lookup = NoImpW Map.lookup
  alter = NoImpW Map.alter
  mapMap = NoImpW Map.mapMap
  unionWith = NoImpW Map.unionWith

instance Bimap r => Bimap (ImpW r) where
  size = NoImpW size
  lookupL = NoImpW lookupL
  lookupR = NoImpW lookupR
  singleton = NoImpW singleton
  empty = NoImpW empty
  insert = NoImpW insert
  toMapL = NoImpW toMapL
  toMapR = NoImpW toMapR
  updateL = NoImpW updateL
  updateR = NoImpW updateR

instance Dual r => Dual (ImpW r) where
  dual = NoImpW dual
  runDual = NoImpW runDual

instance (Prod r, Unit r) => Unit (ImpW r) where
  unit = NoImpW unit

instance (Prod r, Sum r) => Sum (ImpW r) where
  left = NoImpW left
  right = NoImpW right
  sumMatch = NoImpW sumMatch

instance (Prod r, Int r) => Int (ImpW r) where
  int = NoImpW . int
  pred = NoImpW pred
  isZero = NoImpW isZero

instance (Prod r, IO r) => IO (ImpW r) where
  putStrLn = NoImpW putStrLn

instance (Prod r, List r) => List (ImpW r) where
  nil = NoImpW nil
  cons = NoImpW cons
  listMatch = NoImpW listMatch

instance (Prod r, Y r) => Y (ImpW r) where
  y = NoImpW y

instance (Prod r, Functor r x) => Functor (ImpW r) x where
  map = NoImpW map

instance (Prod r, Applicative r x) => Applicative (ImpW r) x where
  ap = NoImpW ap
  pure = NoImpW pure

instance (Prod r, Monad r x) => Monad (ImpW r) x where
  join = NoImpW join
  bind = NoImpW bind

instance (Prod r, VTF.VectorTF r) => VTF.VectorTF (ImpW r) where
  zero = NoImpW VTF.zero
  basis = NoImpW VTF.basis
  plus = NoImpW VTF.plus
  mult = NoImpW VTF.mult
  vtfMatch = NoImpW VTF.vtfMatch

instance (Prod r, DiffWrapper r) => DiffWrapper (ImpW r) where
  diffWrapper = NoImpW diffWrapper
  runDiffWrapper = NoImpW runDiffWrapper

instance (Prod r, Fix r) => Fix (ImpW r) where
  fix = NoImpW fix
  runFix = NoImpW runFix

instance (Prod r, FreeVector r) => FreeVector (ImpW r) where
  freeVector = NoImpW freeVector
  runFreeVector = NoImpW runFreeVector

instance Lang r => Lang (ImpW r) where
  exfalso = NoImpW exfalso
  writer = NoImpW writer
  runWriter = NoImpW runWriter
  float2Double = NoImpW float2Double
  double2Float = NoImpW double2Float
  state = NoImpW state
  runState = NoImpW runState
