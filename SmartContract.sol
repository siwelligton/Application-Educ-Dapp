pragma solidity ^0.4.26;

contract ControlEntity{

struct Government {
    string name;
    string id;
    string password;
}

struct EducationInstitution {
    string nameInstitution;
    string cnpj;
    string password;
    bool statusRecognized; 
}

struct StudentDiploma {
    string nameInstitution;
    string cnpjInstitution;
    string nameStudent;
    string cpf;
    string codeMecCurso;
    string dateAdmission;
    string dateConclusion;
  
}

mapping(string => Government) governments;
string[] public governmentIds;

    
    function registerGovernment (string memory nameGovernment, string memory idGovernment, string memory password) public {
        Government storage newGovernment = governments[idGovernment];
        newGovernment.name = nameGovernment;
        newGovernment.id = idGovernment;
        newGovernment.password = password;
        
        governmentIds.push(idGovernment);
    }


mapping(string => StudentDiploma) students;
string[] public studentIds;

  function bytes32ToString(bytes32 x) public returns (string memory) {
    bytes memory bytesString = new bytes(32);
    uint charCount = 0;
    for (uint j = 0; j < 32; j++) {
        byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
        if (char != 0) {
            bytesString[charCount] = char;
            charCount++;
        }
    }
    bytes memory bytesStringTrimmed = new bytes(charCount);
    for (uint i = 0; i < charCount; i++) {
        bytesStringTrimmed[i] = bytesString[i];
    }
    return string(bytesStringTrimmed);
}


   function registerStudentDiploma(bytes32[] memory _value) public {
        
        uint nameInt = 0;
         uint cnpjInt = 1;
         uint nameStu = 2;
         uint cpfStu = 3;
         uint codeMec = 4;
         uint dateAd = 5;
         uint dateCon = 6;
        
         for (uint i = 0; i < _value.length; i++) {
             
            StudentDiploma storage newStudent = students[bytes32ToString(_value[cpfStu])];
            newStudent.nameInstitution = bytes32ToString(_value[nameInt]);
            newStudent.cnpjInstitution = bytes32ToString(_value[cnpjInt]);
            newStudent.nameStudent = bytes32ToString(_value[nameStu]);
            newStudent.cpf = bytes32ToString(_value[cpfStu]);
            newStudent.codeMecCurso = bytes32ToString(_value[codeMec]);
            newStudent.dateAdmission = bytes32ToString(_value[dateAd]);
            newStudent.dateConclusion = bytes32ToString(_value[dateCon]);
            
            studentIds.push(bytes32ToString(_value[cpfStu]));
            
            if(_value.length == (dateCon+1)){
                break;
            }else{
                nameInt = nameInt+7;
                cnpjInt = cnpjInt+7;
                nameStu = nameStu+7;
                cpfStu = cpfStu+7;
                codeMec = codeMec+7;
                dateAd = dateAd+7;
                dateCon = dateCon+7;
            }
             
         } 
       
    }
    
    function getStudentDiploma(string memory cpf) public view returns (string memory,string memory,string memory, string memory, string memory, string memory, string memory){
        StudentDiploma storage s = students[cpf];
        return (s.nameInstitution,s.cnpjInstitution,s.nameStudent,s.cpf,s.codeMecCurso,s.dateAdmission,s.dateConclusion);
    }

    function getExistDiploma(string memory cpf) public view returns (bool){
        StudentDiploma storage s = students[cpf];
        if(keccak256(abi.encodePacked((s.cpf))) == keccak256(abi.encodePacked((cpf)))){    
            return true;
        }else{
            return false;   
        }
    }
    
    function revokeDiploma(string memory cpf) public {
        
        delete(students[cpf]);
        
    }
    
mapping(string => EducationInstitution) institutions;
string[] public institutionIds;
    

    function registerInstitutionGovernment (string memory nameInstitution, string memory cnpj) public {
    
        EducationInstitution storage newInstitution = institutions[cnpj];
        newInstitution.nameInstitution = nameInstitution;
        newInstitution.cnpj = cnpj;
        newInstitution.statusRecognized = false;
        
        institutionIds.push(cnpj);
    }

    function registerInstitutionEducation (string memory nameInstitution, string memory cnpj,string memory password) public {
    
        EducationInstitution storage institution = institutions[cnpj];
        institution.nameInstitution = nameInstitution;
        institution.cnpj = cnpj;
        institution.password = password;
        institution.statusRecognized = true;
     
    }

    function getValidateInstitution(string memory cnpj) public view returns (bool){
        EducationInstitution storage institution = institutions[cnpj];
        if(keccak256(abi.encodePacked((institution.cnpj))) == keccak256(abi.encodePacked((cnpj)))){    
            return true;
        }else{
            return false;   
        }
    }

    function getInstitution(string memory cnpj) public view returns (string memory, string memory, bool){
        EducationInstitution storage s = institutions[cnpj];
        return (s.nameInstitution,s.cnpj,s.statusRecognized);
    }
    
    function login(string memory cnpj, string memory password, string memory tipoEntidade) public view returns (bool){
        EducationInstitution storage institution = institutions[cnpj]; 
        Government storage government = governments[cnpj]; 
        
        if(keccak256(abi.encodePacked((tipoEntidade))) == keccak256(abi.encodePacked(("ies")))){
                                        
            if(keccak256(abi.encodePacked((institution.cnpj))) == keccak256(abi.encodePacked((cnpj))) &&
               keccak256(abi.encodePacked((institution.password))) == keccak256(abi.encodePacked((password)))){
                return true;
            }else{
                return false;   
            }
        }else{
             if(keccak256(abi.encodePacked((government.id))) == keccak256(abi.encodePacked((cnpj))) &&
               keccak256(abi.encodePacked((government.password))) == keccak256(abi.encodePacked((password)))){
                return true;
            }else{
                return false;   
            }
        }    
    }
    
    
    

}

