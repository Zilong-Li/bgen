# cython: language_level=3, boundscheck=False

from libcpp.string cimport string
from libcpp.vector cimport vector
from libc.stdint cimport uint32_t

from cython.operator cimport dereference as deref

cdef extern from "<iostream>" namespace "std":
    cdef cppclass istream:
        istream& read(char *, int) except +

cdef extern from "<iostream>" namespace "std::ios_base":
    cdef cppclass open_mode:
        pass
    cdef open_mode binary

cdef extern from "<fstream>" namespace "std":
    cdef cppclass ifstream(istream):
        ifstream(const char*) except +
        ifstream(const char*, open_mode) except +

cdef extern from 'variant.h' namespace 'bgen':
    cdef cppclass Variant:
        Variant(ifstream & handle, int layout, int compression, int expected_n) except +
        Variant() except +
        vector[float] alt_dosage()

cdef extern from 'bgen.h' namespace 'bgen':
    cdef cppclass Bgen:
        Bgen(string path, string sample_path) except +
        Variant & operator[](int idx)
        Variant & get(int idx)
        void drop_variants(vector[int] indices)
        vector[string] varids()
        vector[string] rsids()
        vector[string] chroms()
        vector[uint32_t] positions()

cdef class BgenVar:
    cdef Variant * thisptr
    cdef set_var(self, Variant * variant):
        self.thisptr = variant
    def __dealloc__(self):
        del self.thisptr
    def alt_dosage(self):
        return self.thisptr.alt_dosage()

cdef class BgenFile:
    cdef Bgen * thisptr
    def __cinit__(self, path, sample_path=None):
        path = path.encode('utf8')
        if sample_path is None:
            sample_path = ''.encode('utf8')
        self.thisptr = new Bgen(path, sample_path)
    
    def __dealloc__(self):
        del self.thisptr
      
    def __getitem__(self, int idx):
        ''' pull out a Variant by index position
        '''
        variant = self.thisptr.get(idx)
        pvar = BgenVar()
        pvar.set_var(&variant)
        return pvar
    
    def drop_variants(self, list indices):
        ''' drops variants from bgen by indices, for avoiding processing variants
        '''
        self.thisptr.drop_variants(indices)
    
    def varids(self):
      ''' get the varint IDs of all variants in the bgen file
      '''
      varids = self.thisptr.varids()
      return [x.decode('utf8') for x in varids]
    
    def rsids(self):
      ''' get the rsIDs of all variants in the bgen file
      '''
      rsids = self.thisptr.rsids()
      return [x.decode('utf8') for x in rsids]
    
    def chroms(self):
        ''' get the chromosomes of all variants in the bgen file
        '''
        chroms = self.thisptr.chroms()
        return [x.decode('utf8') for x in chroms]
    
    def positions(self):
        ''' get the positions of all variants in the bgen file
        '''
        return self.thisptr.positions()
  
