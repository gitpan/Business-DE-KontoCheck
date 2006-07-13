use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Business::DE::KontoCheck',
#    'DISTNAME'		=> 'Business::DE::KontoCheck',
    'VERSION_FROM'	=> 'lib/Business/DE/KontoCheck.pm', # finds $VERSION
    'PREREQ_PM'		=> {}, # e.g., Module::Name => 1.1
    'LIBS'		=> [''], # e.g., '-lm'
    'DEFINE'		=> '', # e.g., '-DHAVE_SOMETHING'
    'INC'		=> '', # e.g., '-I/usr/include/other'
#		'dist' => {DIST_DEFAULT=>q[clean distcheck disttest ci tardist]},
		#'DIST' => {DIST_DEFAULT=>q[tardist]},
);
