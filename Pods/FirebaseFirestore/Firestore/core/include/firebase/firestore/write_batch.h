/*
 * Copyright 2018 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef FIRESTORE_CORE_INCLUDE_FIREBASE_FIRESTORE_WRITE_BATCH_H_
#define FIRESTORE_CORE_INCLUDE_FIREBASE_FIRESTORE_WRITE_BATCH_H_

namespace firebase {
namespace firestore {

/**
 * A write batch is used to perform multiple writes as a single atomic unit.
 *
 * A WriteBatch object provides methods for adding writes to the write batch.
 * None of the writes will be committed (or visible locally) until commit() is
 * called.
 *
 * Unlike transactions, write batches are persisted offline and therefore are
 * preferable when you don't need to condition your writes on read data.
 */
// TODO(zxu123): add more methods to complete the class and make it useful.
class WriteBatch {};

}  // namespace firestore
}  // namespace firebase

#endif  // FIRESTORE_CORE_INCLUDE_FIREBASE_FIRESTORE_WRITE_BATCH_H_
