import AssemblyKeys._

assemblySettings

name := ""

version := "0.1"

organization := "edu.berkeley.cs.amplab"

scalaVersion := "2.10.4"

parallelExecution in Test := false

libraryDependencies ++= Seq(
  "org.slf4j" % "slf4j-api" % "1.7.2",
  "org.slf4j" % "slf4j-log4j12" % "1.7.2",
  "org.scalatest" %% "scalatest" % "1.9.1" % "test",
  "org.apache.spark" % "spark-core_2.10" % "1.1.0"
)

{
  val defaultHadoopVersion = "1.0.4"
  val hadoopVersion =
    scala.util.Properties.envOrElse("SPARK_HADOOP_VERSION",
defaultHadoopVersion)
  libraryDependencies += "org.apache.hadoop" % "hadoop-client" % hadoopVersion
}

resolvers ++= Seq(
  "Typesafe" at "http://repo.typesafe.com/typesafe/releases",
  "Spray" at "http://repo.spray.cc"
)

mergeStrategy in assembly <<= (mergeStrategy in assembly) { (old) =>
  {
    case PathList("javax", "servlet", xs @ _*)           => MergeStrategy.first
    case PathList(ps @ _*) if ps.last endsWith ".html"   => MergeStrategy.first
    case "application.conf"                              => MergeStrategy.concat
    case "reference.conf"                                => MergeStrategy.concat
    case "log4j.properties"                              => MergeStrategy.discard
    case m if m.toLowerCase.endsWith("manifest.mf")      => MergeStrategy.discard
    case m if m.toLowerCase.matches("meta-inf.*\\.sf$")  => MergeStrategy.discard
    case _ => MergeStrategy.first
  }
}

test in assembly := {}
