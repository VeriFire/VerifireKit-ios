//
//  VFMacros.h
//  Verifire
//
//  Created by Sergey P on 15.08.17.
//  Copyright © 2017 verifire.io. All rights reserved.
//

#ifndef VFMacros_h
#define VFMacros_h

// Base URL
//#define VF_BASE_API_URL @"https://api.verifire.io/"
#define VF_BASE_API_URL @"https://api.verifire.io/"

// Auth Header
#define VF_AUTHORIZATION_HEADER @"X-Authorization"

// Timestamp header
#define VF_TIMESTAMPT_HEADER @"X-Authorization-Timestamp"

// Signature Header
#define VF_SIGNATURE_HEADER @"X-Authorization-Signature"

// Algorithm
#define VF_ALGORITHM_HEADER @"X-Authorization-Algorithm"

// User agent
#define VF_USER_AGENT_HEADER @"User-Agent"

// Default code length
#define VF_PARAMS_DEFAULT_CODE_LENGTH 5

// Localization Macro
#define VFLocalizedString(key, comment) NSLocalizedStringFromTable(key, @"VFVerifire", comment)

// Equality
#define VF_IS_EQUAL(obj1, obj2) (obj1 == obj2 || [obj1 isEqual:obj2])

#endif /* VFMacros_h */
