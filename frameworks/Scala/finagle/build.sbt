lazy val finagleVersion = "19.7.0"

name := "finagle-benchmark"
scalaVersion := "2.12.8"
version := finagleVersion

libraryDependencies ++= Seq(
  "com.twitter" %% "finagle-http" % finagleVersion,
  "com.fasterxml.jackson.module" %% "jackson-module-scala" % "2.9.9"
)

assemblyJarName in assembly := "finagle-benchmark.jar"
assemblyMergeStrategy in assembly := {
 case PathList("META-INF", "services", _*) => MergeStrategy.last
 case PathList("META-INF", _*) => MergeStrategy.discard
 case _ => MergeStrategy.first
}
